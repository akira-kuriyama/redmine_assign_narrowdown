class NarrowdownListener < Redmine::Hook::ViewListener
  def view_issues_edit_notes_bottom(*args)
js=<<'JS'
(function(){
  var narrowdown_select_id = "issue_assigned_to_id_narrowdown";
  var $org_assign_select = $('#issue_assigned_to_id');
  var useridlist = {};
    $("a[href*=users]").each(function(){
      if(/users\/([\d]+)/.test($(this).attr("href"))){
      useridlist[RegExp.$1]=true;
    }
  });
  var $narrowdown_select = $org_assign_select.clone();  
  $org_assign_select.after($narrowdown_select);
  $narrowdown_select.attr('id', narrowdown_select_id)
			  .hide()
			  .attr('disabled', true)
			  .find('option').each(function(){
				    if(!useridlist[$(this).val()]) {
				      $(this).remove();
				    }	
				  });

  var checkbox_and_label_html = '<input type="checkbox" value="" name="" id="only_concerned">';
  checkbox_and_label_html += '<label for="only_concerned" class="inline" style="font-size:80%;">関係者のみ</label>';
  $narrowdown_select.after($(checkbox_and_label_html));
  

  $('#only_concerned').on("change", function(ev) {
    $org_assign_select.toggle();
    $narrowdown_select.toggle();
    if (ev.target.checked) {
    	$org_assign_select.attr('disabled', true);
    	$narrowdown_select.removeAttr('disabled');
    } else {
    	$org_assign_select.removeAttr('disabled');
    	$narrowdown_select.attr('disabled', true);
    }
  });

})();
JS
  js.force_encoding("UTF-8")
  "<script>//<![CDATA[\n#{js}\n//]]></script>"
  end
end
