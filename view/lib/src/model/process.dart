class Process {
  var id = -1;
  var deadline = -1;
  var timeInit = -1;
  var ttf = -1;

  Process(id, time, ttf, deadline) {
    this.id = id;
    this.deadline = deadline;
    this.timeInit = time;
    this.ttf = ttf;
  }

  int getId() {
    return this.id;
  }

  int getDeadline() {
    return this.deadline;
  }

  int getTimeInit() {
    return this.timeInit;
  }

  int getTtf() {
    return this.ttf;
  }

  void setId(int newId) {
    this.id = newId;
  }

  void setDeadline(int newDeadline) {
    this.deadline = newDeadline;
  }

  void setTimeInit(int newTimeInit) {
    this.timeInit = newTimeInit;
  }

  void setTtf(int newTtf) {
    this.ttf = newTtf;
  }

  void updateTtf(int quantum) {
    this.ttf -= quantum;
  }
}
