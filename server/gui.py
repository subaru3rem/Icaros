import pystray
import subprocess as s
from tkinter import *
from server import Main as sub
from PIL import Image, ImageTk
from pystray import MenuItem as item
import threading as t
import sys


class SERVER():
    def __init__(self, base, process):
        self.server_process = process
        self.base = base
        self.frame = Frame(base)
        self.frame.pack()
        self.frame2 = Frame(base)
        self.frame2.pack()
        self.frame3 = Frame(base)
        self.frame3.pack()
        self.alerta = Label(self.frame3, text='')
        self.alerta.pack()
    def inicio(self):
        saudacao = Label(self.frame, text="Icaros")
        saudacao.pack(pady=10)
        
        ip_img = ImageTk.PhotoImage(Image.open('ip_code.png'))
        ip_image = Label(self.frame2, image=ip_img)
        ip_image.image = ip_img
        ip_image.pack(pady=10,padx=10, side="left")
        ip_label = Label(self.frame2, text=sub.GetIp(), font=("arial", 40))
        ip_label.pack(pady=10,padx=10, side="left")

        bnt_init_server = Button(self.frame3, text="Iniciar", command=self.iniciar_servidor)
        bnt_init_server.pack()
        bnt_terminate_server = Button(self.frame3, text="Terminar", command=self.terminate)
        bnt_terminate_server.pack()
    def iniciar_servidor(self):
        self.server_process.start()
    def terminate(self):
        sys.exit()
janela = Tk()
janela.title("Icaros")
janela.geometry("1000x500")
img = PhotoImage(file='icon.png')
janela.iconphoto(False, img)
def quit_window(icon, item):
    icon.stop()
    janela.destroy()
def show_window(icon, item):
    icon.stop()
    janela.after(0,janela.deiconify)
def withdraw_window():  
    janela.withdraw()
    menu = (item('Quit', quit_window), item('Show', show_window))
    image = image = Image.open("icon.png")
    icon = pystray.Icon("name", image, "title", menu)
    icon.run()
def run_gui():
    process = t.Thread(target=sub.run_app, daemon = True)
    sub.CreateQr()
    gui_server = SERVER(janela, process)
    gui_server.inicio()
    janela.mainloop()

janela.protocol("WM_DELETE_WINDOW", withdraw_window)
run_gui()