def _quick_sort_process_by_init_time(process_list):
    if(len(process_list) <= 1):
        return process_list
    else:
        pivot_time = process_list[len(process_list) // 2].getTimeInit()
        left = [p for p in process_list if p.getTimeInit() < pivot_time]
        middle = [p for p in process_list if p.getTimeInit() == pivot_time]
        right = [p for p in process_list if p.getTimeInit() > pivot_time]

        return _quick_sort_process_by_init_time(left) + middle + _quick_sort_process_by_init_time(right)

def rr(process_list, quantum, overload):
    sorted_process_list = _quick_sort_process_by_init_time(process_list)
    n = len(sorted_process_list)
    execution_sequence = []
    list_done = []

    # tempo em q inicia o primeiro processo
    time = sorted_process_list[0].getTimeInit()
    
    # enquanto todos os processos não forem finalizados
    while len(list_done) != n: 

        # para cada processo ainda não finalizado
        for p in sorted_process_list:
            p_ttf = p.getTimeToFinish()
            if p_ttf <= quantum:
                for i in range(p_ttf): execution_sequence.append(p.getId())
                list_done.append(p)
                sorted_process_list.remove(p)
                time += i
            else:
                for i in range(quantum): execution_sequence.append(p.getId())
                for j in range(overload): execution_sequence.append(-1)

                time += (quantum + overload)
                p.updateTimeToFinish(quantum)

            
            
    return execution_sequence