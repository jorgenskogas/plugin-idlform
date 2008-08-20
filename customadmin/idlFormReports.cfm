<cfsetting enablecfoutputonly="yes">

<cfparam name="form.form" default="">
<cfparam name="form.list2" default="">

<cfquery name="forms" datasource="#application.dsn#">
SELECT *
FROM idlForm
</cfquery>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>IDLform report</title>
	
	<style type="text/css">
	* {	
		font-family: "Trebuchet MS", Verdana, Arial, sans-serif;
		font-size: 12px;
		}
		
	h2 {
		font-size:16px;
		}
		
	select.multiple {
		width:150px;
		}
	
	.table1 {
		background-color: ##E7EDF1;
		border-collapse: collapse;
		}
	
	.table1 th,
	.table1 td {
		border: solid 1px ##000000;
		font-family: "Trebuchet MS", Verdana, Arial, sans-serif;
		font-size: 12px;
		padding: 5px;
		text-align: left;
		}
	
	th {
		background-color: ##C9D7E2;
		}
	</style>
	
	<script language="javascript">
		// http://www.mattkruse.com/javascript/selectbox/index.html
		function hasOptions(obj){if(obj!=null && obj.options!=null){return true;}return false;}
		function selectUnselectMatchingOptions(obj,regex,which,only){if(window.RegExp){if(which == "select"){var selected1=true;var selected2=false;}else if(which == "unselect"){var selected1=false;var selected2=true;}else{return;}var re = new RegExp(regex);if(!hasOptions(obj)){return;}for(var i=0;i<obj.options.length;i++){if(re.test(obj.options[i].text)){obj.options[i].selected = selected1;}else{if(only == true){obj.options[i].selected = selected2;}}}}}
		function selectMatchingOptions(obj,regex){selectUnselectMatchingOptions(obj,regex,"select",false);}
		function selectOnlyMatchingOptions(obj,regex){selectUnselectMatchingOptions(obj,regex,"select",true);}
		function unSelectMatchingOptions(obj,regex){selectUnselectMatchingOptions(obj,regex,"unselect",false);}
		function sortSelect(obj){var o = new Array();if(!hasOptions(obj)){return;}for(var i=0;i<obj.options.length;i++){o[o.length] = new Option( obj.options[i].text, obj.options[i].value, obj.options[i].defaultSelected, obj.options[i].selected) ;}if(o.length==0){return;}o = o.sort(
		function(a,b){if((a.text+"") <(b.text+"")){return -1;}if((a.text+"") >(b.text+"")){return 1;}return 0;});for(var i=0;i<o.length;i++){obj.options[i] = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);}}
		function selectAllOptions(obj){if(!hasOptions(obj)){return;}for(var i=0;i<obj.options.length;i++){obj.options[i].selected = true;}}
		function moveSelectedOptions(from,to){if(arguments.length>3){var regex = arguments[3];if(regex != ""){unSelectMatchingOptions(from,regex);}}if(!hasOptions(from)){return;}for(var i=0;i<from.options.length;i++){var o = from.options[i];if(o.selected){if(!hasOptions(to)){var index = 0;}else{var index=to.options.length;}to.options[index] = new Option( o.text, o.value, false, false);}}for(var i=(from.options.length-1);i>=0;i--){var o = from.options[i];if(o.selected){from.options[i] = null;}}if((arguments.length<3) ||(arguments[2]==true)){sortSelect(from);sortSelect(to);}from.selectedIndex = -1;to.selectedIndex = -1;}
		function copySelectedOptions(from,to){var options = new Object();if(hasOptions(to)){for(var i=0;i<to.options.length;i++){options[to.options[i].value] = to.options[i].text;}}if(!hasOptions(from)){return;}for(var i=0;i<from.options.length;i++){var o = from.options[i];if(o.selected){if(options[o.value] == null || options[o.value] == "undefined" || options[o.value]!=o.text){if(!hasOptions(to)){var index = 0;}else{var index=to.options.length;}to.options[index] = new Option( o.text, o.value, false, false);}}}if((arguments.length<3) ||(arguments[2]==true)){sortSelect(to);}from.selectedIndex = -1;to.selectedIndex = -1;}
		function moveAllOptions(from,to){selectAllOptions(from);if(arguments.length==2){moveSelectedOptions(from,to);}else if(arguments.length==3){moveSelectedOptions(from,to,arguments[2]);}else if(arguments.length==4){moveSelectedOptions(from,to,arguments[2],arguments[3]);}}
		function copyAllOptions(from,to){selectAllOptions(from);if(arguments.length==2){copySelectedOptions(from,to);}else if(arguments.length==3){copySelectedOptions(from,to,arguments[2]);}}
		function swapOptions(obj,i,j){var o = obj.options;var i_selected = o[i].selected;var j_selected = o[j].selected;var temp = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);var temp2= new Option(o[j].text, o[j].value, o[j].defaultSelected, o[j].selected);o[i] = temp2;o[j] = temp;o[i].selected = j_selected;o[j].selected = i_selected;}
		function moveOptionUp(obj){if(!hasOptions(obj)){return;}for(i=0;i<obj.options.length;i++){if(obj.options[i].selected){if(i != 0 && !obj.options[i-1].selected){swapOptions(obj,i,i-1);obj.options[i-1].selected = true;}}}}
		function moveOptionDown(obj){if(!hasOptions(obj)){return;}for(i=obj.options.length-1;i>=0;i--){if(obj.options[i].selected){if(i !=(obj.options.length-1) && ! obj.options[i+1].selected){swapOptions(obj,i,i+1);obj.options[i+1].selected = true;}}}}
		function removeSelectedOptions(from){if(!hasOptions(from)){return;}if(from.type=="select-one"){from.options[from.selectedIndex] = null;}else{for(var i=(from.options.length-1);i>=0;i--){var o=from.options[i];if(o.selected){from.options[i] = null;}}}from.selectedIndex = -1;}
		function removeAllOptions(from){if(!hasOptions(from)){return;}for(var i=(from.options.length-1);i>=0;i--){from.options[i] = null;}from.selectedIndex = -1;}
		function addOption(obj,text,value,selected){if(obj!=null && obj.options!=null){obj.options[obj.options.length] = new Option(text, value, false, selected);}}
		
		// http://www.qodo.co.uk/blog/javascript-select-all-options-for-a-select-box/
		function selectAll(selectBox,selectAll) {
			// have we been passed an ID
			if (typeof selectBox == "string") {
				selectBox = document.getElementById(selectBox);
			}
			// is the select box a multiple select box?
			if (selectBox.type == "select-multiple") {
				for (var i = 0; i < selectBox.options.length; i++) {
					selectBox.options[i].selected = selectAll;
				}
			}
		}
	</script>

</head>

<body>
	<h2>Step 1 - Choose form to generate report from</h2>
	<form method="post">
	
		<select name="form">
			<option value=""> - - - Chose form to generate report from - - - </option>
			<cfloop query="forms">
				<option value="#forms.objectid#" <cfif form.form eq forms.objectid>selected="true"</cfif>>#forms.title#</option>
			</cfloop>
		</select>
		
		<input type="submit" value="Step 2 -->">
	
	</form>
</cfoutput>

<cfif Len(form.form)>

	<cfquery name="formlogtitles" datasource="#application.dsn#">
	SELECT title
	FROM idlFormLogItem
	WHERE formlogid IN (
		SELECT objectid
		FROM idlFormLog
		WHERE formid = '#form.form#'
		)
	GROUP BY title
	</cfquery>

	<cfoutput>
		<h2>Step 2 - Select items (and order of these) to include in report</h2>
		<form method="post">
			<input type="hidden" name="form" value="#form.form#">
			<input type="hidden" name="movepattern1" value="">
			
			<table border="0">
			<tr>
				<td>
					Available report items:<br />
					<select class="multiple" name="list1" multiple size="10" onDblClick="moveSelectedOptions(this.form['list1'],this.form['list2'],false,this.form['movepattern1'].value)">
						<cfloop query="formlogtitles">
							<cfif not ListFind(form.list2,formlogtitles.title)>
								<option value="#formlogtitles.title#">#formlogtitles.title#</option>
							</cfif>
						</cfloop>
					</select>
				</td>
				<td>
					<input type="button" name="right" value="&gt;&gt;" onClick="moveSelectedOptions(this.form['list1'],this.form['list2'],false,this.form['movepattern1'].value)"><br /><br />
					<input type="button" name="right" value="All &gt;&gt;" onClick="moveAllOptions(this.form['list1'],this.form['list2'],false,this.form['movepattern1'].value)"><br /><br />
					<input type="button" name="left" value="&lt;&lt;" onClick="moveSelectedOptions(this.form['list2'],this.form['list1'],false,this['form'].movepattern1.value)"><br /><br />
					<input type="button" name="left" value="All &lt;&lt;" onClick="moveAllOptions(this.form['list2'],this.form['list1'],false,this.form['movepattern1'].value)">
				</td>
				<td>
					Selected report items:<br />
					<select class="multiple" name="list2" id="list2" multiple size="10" onDblClick="moveSelectedOptions(this.form['list2'],this.form['list1'],false,this.form['movepattern1'].value)">
						<cfloop list="#form.list2#" index="i">
							<option value="#i#">#i#</option>
						</cfloop>
					</SELECT>
				</td>
				<td>
				<input type="button" value="&nbsp;Up&nbsp;" onClick="moveOptionUp(this.form['list2'])">
				<br /><br />
				<input type="button" value="Down" onClick="moveOptionDown(this.form['list2'])">
				</td>
			</tr>
			</table>
			<input type="button" onClick="selectAll('list2',true);submit(this.form)" value="Generate report">		
		</form>
	</cfoutput>

<cfif ListLen(form.list2)>

	<cfquery name="formlogs" datasource="#application.dsn#">
	SELECT *
	FROM idlFormLog
	WHERE formid = '#form.form#'
	</cfquery>
	
	<cfoutput>
		<h2>Report:</h2>
		<table class="table1">
			<tr>
				<cfloop list="#form.list2#" index="i">
					<th>#i#</th>
				</cfloop>
			</tr>
			
			<cfloop query="formlogs">
				
				<cfquery name="formlogitems" datasource="#application.dsn#">
				SELECT title, value
				FROM idlFormLogItem
				WHERE formlogid = '#formlogs.objectid#'
				</cfquery>
				
				<tr>
					<cfloop list="#form.list2#" index="i">
						<td>
							<cfset thistitle = i>
							<cfloop query="formlogitems">
								<cfif formlogitems.title eq thistitle>
									#formlogitems.value#
								</cfif>
							</cfloop>
						</td>
					</cfloop>
			
				</tr>
			
			</cfloop>
			
		</table>
	</cfoutput>
	
</cfif>
	
</cfif>

</body>
</html>
<cfsetting enablecfoutputonly="no">