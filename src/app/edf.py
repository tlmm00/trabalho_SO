def _quick_sort_process_by_init_time(process_list):
    if(len(process_list) <= 1):
        return process_list
    else:
        pivot_time = process_list[len(process_list) // 2].getTimeInit()
        left = [p for p in process_list if p.getTimeInit() < pivot_time]
        middle = [p for p in process_list if p.getTimeInit() == pivot_time]
        right = [p for p in process_list if p.getTimeInit() > pivot_time]

        return _quick_sort_process_by_init_time(left) + middle + _quick_sort_process_by_init_time(right)

def _get_min_deadline(process_list):
    min_deadline = -1
    min_deadline_process = None

    for p in process_list:
        p_deadline = p.getDeadline()
        if min_deadline == -1 or p_deadline < min_deadline:
            min_deadline = p_deadline
            min_deadline_process = p

    return min_deadline_process, min_deadline

def edf(process_list, quantum, overload):
    sorted_process_list = _quick_sort_process_by_init_time(process_list)
    
    execution_order = []
    shortest_ttf = -1

    time = 0
    for p in sorted_process_list:
        l = [p for p in sorted_process_list if (p.getTimeInit() <= time and p not in execution_order)]

        earliest_deadline_job, _ = _get_min_deadline(l)
        execution_order.append(earliest_deadline_job)

        time += earliest_deadline_job.getTimeToFinish()
    
    print([p.getId() for p in execution_order])

    execution_sequence = []
    for p in execution_order:
        p_ttf = p.getTimeToFinish()
        if p_ttf <= quantum:
            for e in range(p_ttf): execution_sequence.append(p.getId())
        else:
            full_cicles = p_ttf // quantum
            
            for e in range(full_cicles):
                for i in range(quantum): execution_sequence.append(p.getId())
                for j in range(overload): execution_sequence.append(-1)
            
            for i in range(p_ttf % quantum): execution_sequence.append(p.getId())

    return execution_sequence

