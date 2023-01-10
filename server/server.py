from flask import *
import os
import pyautogui as p
from time import sleep
import pygetwindow as gw
import psutil as ps
import subprocess as su
from time import sleep

app = Flask(__name__)

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
    window = gw.getWindowsWithTitle('Google Chrome')
    if not window:
        os.startfile('C:\Program Files\Google\Chrome\Application\chrome.exe')
        sleep(2)
        window = gw.getWindowsWithTitle('Google Chrome')
    try:
        window[0].activate()
    except:
        window[0].minimize()
        window[0].maximize()
    with p.hold('ctrl'):
        p.press('l')
    p.typewrite(link)
    p.press('enter')
def shutdown(parametro): 
    os.system('shutdown '+parametro) 
def cpu_info():
    sleep(.5)
    cpu = ps.cpu_percent(interval=None)
    memory = ps.virtual_memory()[2]
    host = su.check_output('hostname', text=True)
    return {'host':host, 'cpu':f'{cpu}','memory':f'{memory}'}

app.run(host='0.0.0.0', port=5000, debug=True)