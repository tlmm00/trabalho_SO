from app.fifo import fifo
from app.sjf import sjf
from app.edf import edf
from app.rr import rr
from model.process import Process
from flask import Flask, jsonify

def main():
    quantum = 3
    overload = 2

    # l = [
    #         # id, time_init, ttf, deadline
    #     Process(1, 0, 3, 10),
    #     Process(2, 3, 2, 25),
    #     Process(3, 1, 5, 22),
    #     Process(4, 5, 2, 18)
    # ]

    # print("antes:", [p.getId() for p in l])

    # newL = rr(l, quantum, overload)

    # print("depois:", [p for p in newL])

    app = Flask(__name__)

    @app.route('/api/data', methods=['GET'])
    def get_data():
        data = {'message': 'Hello from Python backend!'}
        return jsonify(data)

    if __name__ == '__main__':
        app.run(debug=True)

if __name__ == '__main__':
    main()