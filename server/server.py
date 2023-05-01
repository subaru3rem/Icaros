from flask import *
import os
import qrcode as qr
import socket
import pyautogui as p
from time import sleep
import pygetwindow as gw
import psutil as ps
import subprocess as su
from time import sleep
import webbrowser as web

app = Flask(__name__)
port = 5000

def CreateQr():
    ip = socket.gethostbyname(socket.gethostname())
    price_tag = qr.make(ip+":"+str(port))
    price_tag.save("ip_code.png")


class Cpu_Controler:
    @app.route('/', methods=['GET'])
    def cpu_info():
        host = su.check_output('hostname', text=True)
        cpu = ps.cpu_percent(interval=None)
        memory = ps.virtual_memory()[2]
        disco = ps.disk_usage('/')[3]
        bateria = ps.sensors_battery()[0]
        return {'host':host, 'cpu':str(cpu),'memory':str(memory), 'disco':str(disco), 'bateria':str(bateria)}
    @app.route('/shutdown', methods=["POST"])
    def shutdown():
        parametro =  request.form.get("shutdown")
        timer = request.form.get("timer")
        if timer != None:
            pass
        else:
            os.system('shutdown '+parametro) 
        return "200"
class File_upload:
    @app.route('/file', methods=['POST'])
    def file():
        file = request.files['file']
        if not os.path.isdir('C:/users/caina/downloads/icaro'): 
            os.mkdir('C:/users/caina/downloads/icaro')
        file.save(f'C:/users/caina/downloads/icaro/{file.filename}')
        return '200'
class Navegador:
    @app.route('/navegador', methods=['POST'])
    def navegador():
        link = request.form.get("link")
        web.open(link)
        return "200"
    @app.route('/music', methods=['POST'])
    def music():
        parametro = request.form.get("tecla")
        p.press(parametro)
        return '200'





CreateQr()
app.run(host='0.0.0.0', port=port, debug=True)