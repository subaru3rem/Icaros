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


@app.route('/', methods=['POST'])
def home():
        command = request.get_json(force=True)
        if 'navegador' in command.keys():
           navegador(command['navegador'])
           return '200'
        elif 'multimidia' in command.keys():
            p.press(command['tecla'])
            return '200'
        elif 'shutdown' in command.keys():
            shutdown(command['shutdown'])
            return '200'
        elif 'pc_info' in command.keys():
            return cpu_info()
        else:
            return 'Failed'
def navegador(link):
    google_path = 'C:/Program Files/Google/Chrome/Application/chrome.exe %s'
    web.get(google_path).open(link)
def shutdown(parametro): 
    os.system('shutdown '+parametro) 
def cpu_info():
    sleep(.5)
    cpu = ps.cpu_percent(interval=None)
    memory = ps.virtual_memory()[2]
    host = su.check_output('hostname', text=True)
    return {'host':host, 'cpu':str(cpu),'memory':str(memory)}
@app.route('/file', methods=['POST'])
def file():
    file = request.files['file']
    if not os.path.isdir('C:/users/caina/downloads/icaro'): 
        os.mkdir('C:/users/caina/downloads/icaro')
    file.save(f'C:/users/caina/downloads/icaro/{file.filename}')
    return '200'
def CreateQr():
    ip = socket.gethostbyname(socket.gethostname())
    print(ip)
    price_tag = qr.make(ip+":"+str(port))
    price_tag.save("ip_code.png")
CreateQr()
app.run(host='0.0.0.0', port=port, debug=True)