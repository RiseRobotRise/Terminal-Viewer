extends VBoxContainer	

var terminals : Array = []
var index : int = 0
var term : int = 0
#id : int
#type : PICT/LOGON
#args : IMG/ALGIN
#text : the terminal itself

func create_page(unformatted_terminal : String):
	var page : Dictionary = {}

func add_terminal(unformatted_substring : String):
	var term : Dictionary = {}
	term["pages"] = []
	unformatted_substring = unformatted_substring.trim_prefix("#TERMINAL ")
#	unformatted_substring = unformatted_substring.substr(1)
	var pages = unformatted_substring.split("#END", false)
	for page in pages:
		var appendable :Dictionary = {}
		if page.find("#PICT") != -1:
			appendable["type"]="PICT"
		elif page.find("#CHECKPOINT")!=-1:
			appendable["type"]="CHECKPOINT"
		elif page.find("#INFORMATION")!=-1:
			appendable["type"]="INFORMATION"
		elif page.find("#BRIEFING")!=-1:
			appendable["type"]="BRIEFING"
		else:
			continue
		page.replace("#CHECKPOINT","")
		page.replace("#INFORMATION","")
		appendable["args"]="NONE"
		appendable["text"]="[color=lime]"+page
		term.pages.append(appendable)
#	var start = 0
#	var text
#	var type
#	var args
#	while(start>1):
#		start = min(
#		min(
#		unformatted_substring.find("#PICT"),
#		unformatted_substring.find("#CHECKPOINT")),
#		min(
#		unformatted_substring.find("#INFORMATION"),
#		unformatted_substring.find("#BRIEFING")))
#		var logon = unformatted_substring.find("#LOGON") 
#		var logof = unformatted_substring.find("#LOGOF")
#		if logon < start:
#			text = unformatted_substring.substr(logon, logon+72)
#		elif logof < start:
#			text = unformatted_substring.substr(logof, logof+72)
#		else:
#			text = unformatted_substring.substr(start, unformatted_substring.find("#END"))
	
	
#	term.pages.append(text) 
	terminals.append(term)
	
func split_terminals(text : String):
	terminals.clear()
	text.trim_prefix(";")
	var terminals = text.split("#ENDTERMINAL", false)
	for terminal in terminals:
		add_terminal(terminal)
	display_page(0,0)

	
func display_page(terminal : int, id : int):
	$Information/Terminals.text = "Terminals :"+str(terminals.size())
	if terminal < 0 or id < 0 or terminal >= terminals.size():
		return
	if id >= terminals[terminal].pages.size():
		return
	$Information/Pages.text = "Pages :"+str(terminals[terminal].pages.size())
	var page = terminals[terminal].pages[id]
	if page.type == "PICT" or "CHECKPOINT":
		$PICT/Texture.visible = true
		$PICT.columns = 2
		$PICT/Terminal.visible_characters = 990
		if "RIGHT" in page.args:
			$PICT/Texture.set_as_toplevel(true)
	elif page.type == "LOGON":
		$PICT/Texture.visible = true
		$PICT.columns = 1
		$PICT/Terminal.visible_characters = 72
	elif page.type == "INFORMATION" or "BRIEFING":
		$PICT/Texture.visible = false
		$PICT.columns = 1
		$PICT/Terminal.visible_characters = 1584
	$PICT/Terminal.bbcode_text = page.text


func _on_Prev_pressed():
	if index > 0:
		index -= 1
		display_page(term, index)


func _on_Next_pressed():
	if index < terminals[term].pages.size()-1:
		index+=1
		display_page(term, index)


func _on_Prev_term_pressed():
	if term > 0:
		term-=1
		index=0
		display_page(term,index)
		


func _on_Next_term_pressed():
	if term < terminals.size()-1:
		term+=1
		index=0
		display_page(term,index)
