from flask import Flask, render_template, abort, redirect, request
import datetime
import socket

app = Flask(__name__)	

@app.route('/',methods=["GET","POST"])
def inicio():
    hoy=datetime.datetime.now()
    return render_template("inicio.html",hoy=hoy,server=socket.gethostname())



app.run('0.0.0.0',3000,debug=True)