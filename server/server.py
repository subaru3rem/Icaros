from flask import *
import os
import pyautogui as p
from time import sleep
import pygetwindow as gw

app = Flask(__name__)

@app.route('/', methods=['POST'])
def home():
    try:
        url = request.get_json(force=True)
        if url['link']:
            window = gw.getWindowsWithTitle('Google Chrome')
            if not window:
                os.startfile('C:\Program Files\Google\Chrome\Application\chrome.exe')
                sleep(2)
                window = gw.getWindowsWithTitle('Google Chrome')
            window[0].minimize()
            window[0].maximize()
            sleep(.5)
            with p.hold('ctrl'):
                p.press('l')
            p.typewrite(url['link'])
            p.press('enter')
            return 'accepted'
        else:
            return 'failed'
    except:
        return 'failed'
    


app.run(host='0.0.0.0', port=5000, debug=True)