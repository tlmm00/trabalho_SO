from app.fifo import fifo
from app.sjf import sjf
from app.edf import edf
from model.process import Process

def main():
    quantum = 3
    overload = 2

    l = [
            # id, time_init, ttf, deadline
        Process(1, 0, 3, 10),
        Process(2, 3, 2, 25),
        Process(3, 1, 5, 22),
        Process(4, 5, 2, 18)
    ]

    print("antes:", [p.getId() for p in l])

    newL = edf(l, quantum, overload)

    print("depois:", [p for p in newL])

if __name__ == '__main__':
    main()