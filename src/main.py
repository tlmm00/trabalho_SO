from app.fifo import fifo
from app.sjf import sjf
from app.edf import edf
from app.rr import rr
from model.process import Process
from flask import Flask, request

app = Flask(__name__)

@app.route('/FIFO')
def do_fifo():

    # data = request.json

    ovld = request.args.get('params')['overload']
    qtm = request.args.get('params')['quantum']
    query_process = request.args.get('processes')

    id = 0
    process_list = []
    for p in query_process:
        process_list.append(
            Process(id, p['initTime'], p['timeToFinish'], p['deadline']))
        id+=1

    return fifo(process_list)

@app.route('/EDF', methods=['GET', 'POST'])
def do_edf():
    print('Hello from EDF!')
    return 'Hello from EDF!'

@app.route('/RR', methods=['GET', 'POST'])
def do_rr():
    print('Hello from RR!')
    return 'Hello from RR!'

@app.route('/SJF', methods=['GET', 'POST'])
def do_sjf():
    print('Hello from SJF!')
    return 'Hello from SJF!'



