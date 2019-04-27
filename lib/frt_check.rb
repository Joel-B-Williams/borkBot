module Frt_check

  def get_from(inbox, icom)
    icom.conversations.find_all(open: true, type: "admin", id: inbox)
  end
  
  def get_full_convos(convo_list, icom)
    convo_list.map {|convo| convo.id}.map {|id| icom.conversations.find(id: id)}
  end
  
  def get_assignment_times(full_convos, inbox)
    full_convos.map do |convo|
      convo.conversation_parts.select { |p| (p.part_type=="assignment") && (p.assigned_to.id==inbox.to_s) }.max_by(&:created_at)
    end
  end

  def get_reds(assignment_parts, kpi_limit)
    assignment_parts.select {|assign| assign.created_at.to_i < kpi_limit}
  end

  def red_count(inbox, kpi_limit, icom)
    convos = get_from(vip_inbox, icom) 
    full_convos = get_full_convos(convos, icom)
    assign_times = get_assignment_times(full_convos, vip_inbox)
    red_convos_count = get_reds(assign_times, kpi_limit).length
  end

end