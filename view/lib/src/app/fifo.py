def _quick_sort_process_by_init_time(process_list):
    if(len(process_list) <= 1):
        return process_list
    else:
        pivot_time = process_list[len(process_list) // 2].getTimeInit()
        left = [p for p in process_list if p.getTimeInit() < pivot_time]
        middle = [p for p in process_list if p.getTimeInit() == pivot_time]
        right = [p for p in process_list if p.getTimeInit() > pivot_time]

        return _quick_sort_process_by_init_time(left) + middle + _quick_sort_process_by_init_time(right)

def fifo(process_list):
    sorted_process_list = _quick_sort_process_by_init_time(process_list)
    return sorted_process_list
