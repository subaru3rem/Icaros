from flask import *
import os
import pyautogui as p
from time import sleep
import pygetwindow as gw

app = Flask(__name__)

@app.route('/', methods=['POST'])
def home():
        command = request.get_json(force=True)
        if 'navegador' in command.keys():
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
                print('erro activate')
            with p.hold('ctrl'):
                p.press('l')
            p.typewrite(command['navegador'])
            p.press('enter')
            return 'Accepted'
        elif 'multimidia' in command.keys():
            p.press(command['tecla'])
            return '200'
        elif 'rotina' in command.keys():
            pass
        else:
            return 'Failed'

    


app.run(host='0.0.0.0', port=5000, debug=True)