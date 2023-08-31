from deep_translator import GoogleTranslator
from selenium.webdriver.common.by import By
from bs4 import  BeautifulSoup as b
from selenium import webdriver
from threading import Thread
from flask import *
import mysql.connector as sql
import base64 as enconder
import webbrowser as web
import subprocess as su
import pyautogui as p
import psutil as ps
import qrcode as qr
import socket
import time
import os
import re

#conexão com o banco de dados
mydb = sql.connect(
    host="192.168.10.60",
    user="subaru3rem",
    password="93439978",
    database="icaros",
    auth_plugin='mysql_native_password'
)
cursor = mydb.cursor()

#instanciar flask
app = Flask(__name__)
port = 5000

class Main():
    def CreateQr(self):
        #pega o ip da maquina
        ip = self.GetIp()
        #transforma a string do ip em um qrcode
        price_tag = qr.make(ip+":"+str(port))
        #salva o qr code
        price_tag.save("ip_code.png")
    def GetIp(self):
        #usa a biblioteca de socket para descobrir o ip da maquina
        ip = socket.gethostbyname(socket.gethostname())
        return ip
    def run_app(self):
        #cria as threads usadas no programa e rodas elas em paralelo
        novel_controller = NovelController()
        thread = Thread(target=novel_controller.executeController)
        thread.start()
        app.run(host='0.0.0.0', port=port)
#instancia a classe main
controller = Main()


class Cpu_Controler:
    #rota home do servidor que só aceita gets
    @app.route('/', methods=['GET'])
    def cpu_info():
        #pega infos do hardware do pc como uso da cpu, memoria e uso do disco
        host = su.check_output('hostname', text=True)
        cpu = ps.cpu_percent(interval=None)
        memory = ps.virtual_memory()[2]
        disco = ps.disk_usage('/')[3]
        #bateria = ps.sensors_battery()[0]
        
        #retorna tudo em um dict
        return {'host':host, 'cpu':str(cpu),'memory':str(memory), 'disco':str(disco)}
    #rota de desligamento do pc, só recebe requisição post
    @app.route('/shutdown', methods=["POST"])
    def shutdown():
        #pega o comando já montado
        parametro =  request.form.get("shutdown")
        #roda o comando no sistema
        os.system('shutdown '+parametro) 
        return "200"
    

class File_upload:
    #metodo de envio de arquivo, so aceita requisição post
    @app.route('/file', methods=['POST'])
    def file():
        #pega o arquivo que vem da requisição
        file = request.files['file']
        #cria uma string com o caminho para a pasta do projeto
        file_path = os.path.expanduser('-/downloads/icaros')
        #caso a pasta não exista, cria ela
        if not os.path.isdir(file_path): 
            os.mkdir(file_path)
        #salva o arquivo na pasta
        file.save(os.path.join(file_path, file.filename))
        return '200'


class Navegador:
    #rota para abrir site no navegador, so aceita metodo post
    @app.route('/navegador', methods=['POST'])
    def navegador():
        #pega o link que vem na requisição
        link = request.form.get("link")
        #abre o link no navegador
        web.open(link)
        return "200"
    #rota que controla a multmidia do pc, aceita post
    @app.route('/music', methods=['POST'])
    def music():
        #pega o comando como tecla que vem na requisição
        parametro = request.form.get("tecla")
        #simula o pressionamento da tecla com o comando da requisição
        p.press(parametro)
        return '200'
    

class Leitor:
    #rota de novel do leitor, aceita todos os metodos de crud
    @app.route("/api/novel", methods=["GET", "POST", "PUT", "DELETE"])
    def Novels():
        #verifica o methodo da requisição
        if request.method == "GET":
            #seleciona o id, nome e o caminho da imagem das novels
            cursor.execute("select * from novels")
            all_novels = cursor.fetchall()
            #transforma a tupla retornada em um dicionario
            column_names = [i[0] for i in cursor.description]
            dict_novels = [dict(zip(column_names, row)) for row in all_novels]
            #roda todas as novels e codifica a novel antes de retornar uma resposta
            for i in dict_novels: i["img"] = enconder.b64encode(open(i["imgPath"],"rb").read()).decode('utf-8') if i["imgPath"] else ""
            return dict_novels
        elif request.method == "POST":
            #pega os dados da requisição
            data = request.form.to_dict()
            img = request.files.get("ImgNovel")
            #salva a imagem caso tenha alguma
            if img:
                #pega o caminho do servidor
                path = os.getcwd()
                #adiciona a pasta da imagem no caminho do servidor
                imgPath = os.path.join(path, 'images_novels')
                #adiciona o arquivo ao caminho
                imgFile = os.path.join(imgPath, img.filename.replace(" ", "_"))
                #salva no caminho construido acima
                img.save(imgFile)
            else:
                #caso n tenha imagem, salva uma string vazia
                imgFile = ""
            #insere a novel no banco de dados
            data["imgFile"] = imgFile.replace(os.sep, '/')
            cursor.execute(
                """insert into novels (nome, link, ImgPath, traduzido)
                values(%(nome)s, %(link)s, %(imgFile)s, %(traduzido)s""",
                data
            )
            mydb.commit()
            return "sucess"
        elif request.method == "PUT":
            #pega os dados da requisição
            data = request.form.to_dict()
            img = request.files.get("ImgNovel")
            #salva novamente a imagem caso venha algo(metodo igual ao anterior)
            if img:
                path = os.getcwd()
                imgPath = os.path.join(path, 'images_novels')
                imgFile = os.path.join(imgPath, img.filename.replace(" ", "_"))
                img.save(imgFile)
            else:
                imgFile = ""
            #altera os registros no banco
            data["imgFile"] = imgFile.replace(os.sep, '/')
            cursor.execute(
                """update novels 
                set nome=%(nome)s,
                link=%(link)s , 
                imgPath=%(imgFile)s,
                traduzido = %(traduzido)s 
                where id = %(id)s""",
                data
            )
            mydb.commit()
            return "updated"
        elif request.method == "DELETE":
            #pega os dados da requisição
            data = request.form.to_dict()
            #pega o caminho da imagem do banco
            cursor.execute(
                """select imgPath 
                from novels 
                where id = %(id)s""",
                data
            )
            #deleta imagem 
            imgPath = cursor.fetchone()[0]
            if imgPath:
                os.remove(imgPath)
            #deleta a novel do banco
            cursor.execute(
                """delete from novels 
                where id=%(id)s""",
                data
            )
            mydb.commit()
            return "deleted"
    @app.route("/api/novel/caps", methods = ["GET", "PUT"])
    def GetNovelCaps():
        #pega os parametros no link da requisição
        tipo = request.args.get('tipo', type=int)
        #verifica o metodo da requisição
        if request.method == "GET":
            #pega o parametro no link da requisição
            id_novel = request.args.get('id_novel')
            #pega os caps do banco
            cursor.execute("""select id, nomeCap, checkLido 
                           from capsnovel 
                           where idNovel = %s
                           order by CHAR_LENGTH(linkCap), linkCap""",
                           [id_novel])
            caps = cursor.fetchall()
            #cria uma lista de dicionarios
            dict_caps = []
            #adiciona os valores recuperados do banco a lista como um objeto
            for i in caps:
                dict_caps.append({
                    "id":i[0],
                    "name": i[1],
                    "lido":True if i[2] else False
                })
            #retorna o dicionario
            return dict_caps
        elif tipo == 0:
            #pega o id do link do cap
            id_cap = request.form.get("id")
            #alterna o estado de leitura de um capitulo unico
            cursor.execute(
                """update capsnovel
                set checkLido = not checkLido 
                where id = %s""",
                [id_cap]
            )
            mydb.commit()
            return "capitulo alterado"
        else:
            #pega os atributos da requisição
            position = request.form.get("position")
            id_novel = request.form.get("id_novel")

            #altera o estado de todos os caps antes do selecionado
            cursor.execute(
                """update capsnovel
                set checkLido = true
                where idNovel = %s
                order by idNovel, char_length(linkCap), linkCap
                limit %s;""",
                [id_novel, position]
            )
            mydb.commit()
            return "capitulos alterados"
    @app.route("/api/novel/cap")
    def GetCap():
        #pega o atributo da url
        id_cap = request.args.get('id_cap', type=int)
        #pega o conteudo do cap do banco
        cursor.execute("select conteudoCap from capsnovel where id = %s;", [id_cap])
        text = cursor.fetchone()[0]
        #retorna o texto salvo
        return text


class NovelController:
    def executeController(self):
        #verifica se ocorreu algum erro ao rodar o programa
        try:
            #chama todas as funções da classe que gerencia o servidor
            self.getCaps()
            self.updateNovel()
            self.getContent()
            self.translateContent()
        except Exception as e:
            #salva o erro no banco
            cursor.execute(
                """insert into erros (message, dateError)
                values (%s, current_date)""",
                [e]
            )
            mydb.commit()
            #roda o programa novamente
            self.executeController()
        #da uma pausa de 4 horas até rodar a função novamente
        time.sleep((1*60*60)*4)
        #chama a função novamente formando um looping
        self.executeController()
    def getCaps(self):
        #pega o id e o link das novels sem cap cadastrado
        cursor.execute(
            """select n.id, n.link
            from novels n
            left join capsnovel c
            on n.id = c.idNovel
            where c.idNovel is null;"""
        )
        novelNullCaps = cursor.fetchall()
        #roda em todas as novas novels
        for novel in novelNullCaps:
            #inicia o navegador e abre o site
            driver = webdriver.Chrome()
            driver.get(novel[1])
            #espera para o site carregar
            time.sleep(2)
            #pega todo o conteudo do site
            html = driver.execute_script("return document.getElementsByTagName('html')[0].innerHTML")
            #transforma em um objeto gerenciavel
            parsed = b(html, 'html.parser')
            #pega todos os elementos do site com a tag a
            a = parsed.find_all('a')
            #passa por todos as tags
            for caps in a:
                try:
                    #pega os textos dentro das tags a separandos eles com um espaço
                    nome_cap = caps.get_text(" ")
                    #limpa todos os grandes espaços e quebras de liha desnecessarias
                    nome = nome_cap.replace("\n", "").replace("  ", "")
                    #verifica se dentro desse texto existe uma definição de capitulo ou se não possui numero do cap
                    if not re.search("Chapter", nome) or not re.search("\d", nome): continue
                    #salva o capitulo no banco
                    cursor.execute("insert into capsnovel (idNovel,nomeCap, linkCap) values (%s, %s, %s)",
                                   [novel[0], nome, caps.get('href')])
                    mydb.commit()
                except Exception as e:
                    #salva o erro no banco caso aconteça
                    cursor.execute(
                        """insert into erros (message, dateError)
                        values (%s, current_date)""",
                        [e]
                    )
                    mydb.commit()
            #fecha o navegador
            driver.quit()
    def getContent(self):
        #pega  todos os caps sem conteudo
        cursor.execute(
            """select id, linkCap
            from capsnovel
            where conteudoCap is null
            order by idNovel, CHAR_LENGTH(linkCap), linkCap;"""
        )
        capsNullConteudo = cursor.fetchall()
        #roda todos os caps
        for caps in capsNullConteudo:
            #abre o navegador
            driver = webdriver.Chrome()
            try:
                #abre o site no navegador
                driver.get(caps[1])
                #pega o html do site
                html = driver.execute_script("return document.getElementsByTagName('html')[0].innerHTML")
                #transforma em objeto gerenciavel
                parsed = b(html, 'html.parser')
                #pega todos os paragrafos do html
                strings = parsed.find_all('p')
                #tranforma tudo em um grande texto
                text = "\n".join(s.get_text() for s in strings)
                #salva o conteudo no banco
                cursor.execute(
                    """Update capsnovel 
                    set conteudoCap = %s 
                    where id = %s""",
                    [text, caps[0]]
                )
                mydb.commit()
                #fecha o navegador
                driver.quit()
            except Exception as e:
                #salva o erro no banco caso ocorra
                cursor.execute(
                    """insert into erros (message, dateError)
                    values (%s, current_date)""",
                    [e]
                )
                mydb.commit()
                #fecha o navegador
                driver.quit()
                #chama a função novamente para tentar resolver o erro novamente
                self.getContent()
    def translateContent(self):
        cursor.execute(
            """select c.id, c.conteudoCap
            from capsnovel c
            inner join novels n
            on c.idNovel = n.id
            where c.traduzido = false 
            and c.conteudoCap is not null 
            and n.traduzido = false;"""
        )
        text = cursor.fetchall()
        for t in text:
            strings = t[1].split("\n")
            count = 0
            for s in strings:
                if not re.search("[a-zA-z]", s) and s == None: count += 1; continue
                strings[count] = GoogleTranslator(source='auto', target='pt').translate(text=s)
                count += 1
            text_traduzido = "\n".join(s if s else '' for s in strings)
            cursor.execute(
                """update capsnovel
                set conteudoCap = %s,
                traduzido = 1
                where id = %s""",
                [text_traduzido, t[0]]
            )
            mydb.commit()
    def updateNovel(self):
        #pega o id e o link das novels
        cursor.execute(
            """select id, link
            from novels"""
        )
        allNovels = cursor.fetchall()
        #roda em todas as novels
        for novel in allNovels:
            #abre o navegador
            driver = webdriver.Chrome()
            try:
                #abre o site no navegador
                driver.get(novel[1])
                #espera a pagina carregar
                time.sleep(2)
                #pega o html da pagina
                html = driver.execute_script("return document.getElementsByTagName('html')[0].innerHTML")
                #transforma o html em um objeto gerenciavel
                parsed = b(html, 'html.parser')
                #pega todos os links
                a = parsed.find_all('a')
                #passa por todos as tags a
                for caps in a:
                    #pega o texto dos capitulos
                    nome_cap = caps.get_text(" ")
                    #limpa o texto dos links
                    nome = nome_cap.replace("\n", "").replace("  ", "")
                    #valida se possui chapter e um numeros nos links
                    if not re.search("Chapter", nome) or not re.search("\d", nome): continue
                    #verifica se o capitulo ja existe no banco
                    cursor.execute(
                        """select true as Existe
                        from capsnovel 
                        where linkCap = %s""",
                        [caps.get('href')]
                    )
                    exist = cursor.fetchone()
                    #caso exista ele passa direto
                    if exist:
                        continue
                    #caso não exista, insere o capitulo no banco
                    cursor.execute("insert into capsnovel (idNovel,nomeCap, linkCap) values (%s, %s, %s)",
                        [novel[0], nome, caps.get('href')])
                    mydb.commit()
            except Exception as e:
                #salva o erro no banco caso ocorra um erro
                cursor.execute(
                    cursor.execute(
                        """insert into erros (message, dateError)
                        values (%s, current_date)""",
                        [e]
                    )
                )
                mydb.commit()
            #fehca o navegador
            driver.quit()

#inicia todo o programa
controller.run_app()