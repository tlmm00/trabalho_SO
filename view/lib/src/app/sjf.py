def _quick_sort_process_by_init_time(process_list):
    if(len(process_list) <= 1):
        return process_list
    else:
        pivot_time = process_list[len(process_list) // 2].getTimeInit()
        left = [p for p in process_list if p.getTimeInit() < pivot_time]
        middle = [p for p in process_list if p.getTimeInit() == pivot_time]
        right = [p for p in process_list if p.getTimeInit() > pivot_time]

        return _quick_sort_process_by_init_time(left) + middle + _quick_sort_process_by_init_time(right)

def _get_min_ttf(process_list):
    min_ttf = -1
    min_ttf_process = None

    for p in process_list:
        p_ttf = p.getTimeToFinish()
        if min_ttf == -1 or p_ttf < min_ttf:
            min_ttf = p_ttf
            min_ttf_process = p

    return min_ttf_process, min_ttf

def sjf(process_list):
    sorted_process_list = _quick_sort_process_by_init_time(process_list)
    
    execution_order = []
    shortest_ttf = -1

    time = min([p.getTimeInit() for p in process_list])
    for p in sorted_process_list:
        l = [p for p in sorted_process_list if (p.getTimeInit() <= time and p not in execution_order)]
        
        shortest_job, min_process_ttf = _get_min_ttf(l)
        execution_order.append(shortest_job)

        sorted_process_list.remove(shortest_job)

        time += min_process_ttf
        # sorted_process_list.remove(shortest_job)
        

    return execution_order