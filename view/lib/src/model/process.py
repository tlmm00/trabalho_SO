

class Process():
    id = -1
    deadline = -1
    time_init = -1
    ttf = -1
    finish = False

    def __init__(self, id, time, ttf, deadline):
        self.id = id
        self.time_init = time
        self.deadline = deadline
        self.ttf = ttf

    def getId(self):
        return self.id
    
    def getDeadline(self):
        return self.deadline
    
    def getTimeInit(self):
        return self.time_init

    def getTimeToFinish(self):
        return self.ttf

    def updateTimeToFinish(self, quantum):
        self.ttf -= quantum

    def isFinish(self):
        return self.finish

    def setFinishedTrue(self):
        self.finish = True