<cfsetting enablecfoutputonly="yes" />
<!--- @@Copyright: Copyright (c) 2008 IDLmedia AS. All rights reserved. --->
<!--- @@License:
	This file is part of FarCry Form Builder Plugin.

	FarCry Form Builder Plugin is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	FarCry Form Builder Plugin is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with FarCry Form Builder Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->

<!--- @@displayname: --->
<!--- @@description: This template will attemt to use the cfjq_forms custom tag for form client side validation services.
					 Should the custom tag not be installed on the server the template will run like a normal attributes.placeError form without any validation. --->
<!--- @@author: Trond Ulseth (trond@idl.no) & Jørgen M. Skogås (jorgen@idl.no) --->

<cfparam name="attributes.objectID" default="" />	<!--- The objectID of the form --->
<cfparam name="attributes.formInfo" default="" /> 	<!--- The form info text --->
<cfparam name="attributes.sendtText" default="" /> 	<!--- The form sendt text --->
<cfparam name="attributes.submitText" default="" />	<!--- The text in the submitbutton --->
<cfparam name="attributes.aFormItems" default="" />	<!--- The array with formitems objectIDs --->
<cfparam name="attributes.class" default="" />		<!--- form tags class --->
<cfparam name="attributes.id" default="ID#replace(attributes.objectID, '-', '', 'ALL')#" />			<!--- form tags id --->

<!--- For validation: --->
<cfparam name="attributes.form_class" default="cfjq_form1" /> <!--- !!! validation will only work on 1 form per page right now --->
<cfparam name="attributes.placeError" default="inline" />	<!----if "box" validation error message will be placed in a box over the form--->
<cfparam name="attributes.ajax" default="false" />		<!--- If we want to use Ajax submitions at a later time!!! --->
<cfparam name="skipValidation" default="false" />

<cfparam name="errormessage" default="" />
	
<cfset oFormItemService = createObject("component", application.stCoapi.idlFormItem.packagepath) />

<cfif thistag.executionMode eq "Start">
	
	<!--- Set form action URL --->
	<cfset formActionURL = #application.fapi.getLink(objectID=request.stObj.objectID)# />
	
	<cfif trim(attributes.class) is "">
		<cfset attributes.class = "idlform">
	</cfif>

	<!--- include idlform.css stylesheet - if attributes.class is idlform --->
	<cfif attributes.class is "idlform">
		<cfhtmlhead text='<link rel="stylesheet" type="text/css" href="/css/idlform.css" media="all" />'>
	</cfif>

	<cfif StructKeyExists(form,"submitidlform")>
		<!--- server side validation - In the future this should probably be moved to its own validate object --->
		
			<!--- Loop through the form items --->
			<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
				
				<!--- Get info about this item --->
				<cfset stObjFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i])>

				<cfset isValid = true>
				
				<!--- if the form is of type textfield or textarea we do the following validation --->
				<cfif stObjFormItem.type is "textfield" or stObjFormItem.type is "textarea">
					
					<!--- check if it is required --->
					<cfif (stObjFormItem.validateRequired is 1) and (len(trim(form[stObjFormItem.objectID])) is 0)>
						<cfset isValid = false>
					</cfif>
					
					<!--- validate digits --->
					<cfif stObjFormItem.validateType is "digits" or stObjFormItem.validateType is "number">
						<cfif (stObjFormItem.validateRequired is 0 AND len(trim(form[stObjFormItem.objectID])) GT 0)
						   OR (stObjFormItem.validateRequired is 1)>
							<!--- check if it has a minimum value --->
							<cfif (stObjFormItem.validateMinLength gt form[stObjFormItem.objectID] AND stObjFormItem.validateMinLength NEQ 0) AND IsNumeric(form[stObjFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
							<!--- check if it has a maximum value --->
							<cfif (stObjFormItem.validateMaxLength lt form[stObjFormItem.objectID] AND stObjFormItem.validateMaxLength NEQ 0) AND IsNumeric(form[stObjFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfif>
					<cfelse>
					<!--- validate string lengths --->
						<cfif (stObjFormItem.validateRequired is 0 AND len(trim(form[stObjFormItem.objectID])) GT 0)
						   OR (stObjFormItem.validateRequired is 1)>
							<!--- check if it has a minimum length --->
							<cfif IsNumeric(stObjFormItem.validateMinLength) and stObjFormItem.validateMinLength gt len(trim(form[stObjFormItem.objectID]))>
								<cfset isValid = false>
							</cfif>
							<!--- check if it has a maximum length --->
							<cfif IsNumeric(stObjFormItem.validateMaxLength) and stObjFormItem.validateMaxLength lt len(trim(form[stObjFormItem.objectID])) AND stObjFormItem.validateMaxLength NEQ 0>
								<cfset isValid = false>
							</cfif>
						</cfif>
					</cfif>
					
					<cfswitch expression="#stObjFormItem.validateType#">
						<cfcase value="digits">
							<cfif (not IsValid("integer",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("integer",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="number">
							<cfif (not IsValid("numeric",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("numeric",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="date">
							<cfif (not IsValid("eurodate",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("eurodate",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="creditcard">
							<cfif (not IsValid("creditcard",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("creditcard",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="url">
							<cfif (not IsValid("URL",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("URL",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="email">
							<cfif (not IsValid("email",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("email",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
					</cfswitch>
				</cfif>
				
				<!--- if the form is of type checkbox or radiobutton we do the following validation --->
				<cfif stObjFormItem.type is "checkbox" or stObjFormItem.type is "radiobutton">
					<!--- TODO: add validation here --->
				</cfif>
				
				<cfif NOT isValid>
					<!--- add info to the error message --->
					<cfset errorMessage = Insert("<span class='label'>#stObjFormItem.label#:</span> <span class='errortext'>#stObjFormItem.validateErrorMessage#</span><br />", errorMessage, Len(errorMessage))>
				</cfif>
				
			</cfloop>
			
	</cfif>
	
	<!--- check if form is submitted and validation passed --->
	<cfif StructKeyExists(form,"submitidlform") and Len(errormessage) is 0>
		
		<!--- send the content of the submited form by e-mail --->
		<!--- TODO: Sjekk hva stSubmitForm returnerer, denne skal ha status på lagring, osv. Dette må testes, --->
		<cfset stSubmitForm = createObject("component", application.stCoapi.idlForm.packagepath).submit(objectID=#attributes.objectID#,formData=#form#) />
		
		<cflocation url="#formActionURL#?bFormSaved=true###attributes.id#" addtoken="false" />
	
	<cfelseif structkeyexists(url, "bFormSaved")>
		
		<!--- Form is saved --->
		<cfsavecontent variable="tagoutput">
			<!--- confirmation: respons to the user  --->
			<cfoutput>
				<div id="#attributes.id#" class="idlConfirmation">
					#attributes.sendtText#
				</div>
			</cfoutput>
		</cfsavecontent>
		
	<cfelse>
		
		<cfoutput>
			<div id="#attributes.id#">
		</cfoutput>
	
		<cfif Len(errormessage) gt 0>
			<cfoutput>
				<div class="idlform_errorMessage">
					#errorMessage#
				</div>
			</cfoutput>
		</cfif>

		<!--- 	set comma delimeted list with input types which should not have a label - 
				hidden should ALWAYS be in this list  --->
		<cfset noLabel = "hidden,statictext">
		
		<cfoutput>
			<cfif trim(attributes.formInfo) NEQ "">
				<div class="idlFormInfo">#attributes.formInfo#</div>
			</cfif>
			
			<cftry>
				<cf_cfJq_forms action="#formActionURL#" enctype="multipart/form-data" method="post" jqFolder="/jquery/cfjq"  css_class="#attributes.class#">
			<cfcatch type="any">
				<form action="#formActionURL####attributes.id#" method="post" enctype="multipart/form-data" name="idlform" class="#attributes.class#">
				<cfset skipValidation = "true">
			</cfcatch>
			</cftry>
		</cfoutput>
		
		<cfsavecontent variable="tagoutput">
		<!--- loop over items --->
			<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
			
			<!--- get formitem data --->
			<cfset stObjFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i])>
			
			<cfif stObjFormItem.type neq "hidden">
				
				<!--- Add classes --->
				<cfsavecontent variable="fieldsetClasses">
					<cfif trim(stObjFormItem.width) NEQ "" OR trim(stObjFormItem.class) NEQ "">
	
						<cfoutput> class="</cfoutput> <!--- Start class --->
							
							<cfif trim(stObjFormItem.width) NEQ "">
								<cfoutput>#trim(stObjFormItem.width)# </cfoutput>
							</cfif>
							
							<cfif trim(stObjFormItem.class) NEQ "">
								<cfoutput>#trim(stObjFormItem.class)#</cfoutput>
							</cfif>
							
						<cfoutput>" </cfoutput> <!--- End class --->
					</cfif>
					
				</cfsavecontent>
					
				<cfoutput>#"<fieldset" & fieldsetClasses & ">"#</cfoutput>
				
			</cfif>
			
			<!--- create validation rule --->
			<cfset validationRule = "">
			
			<cfif skipValidation eq false>
			
				<cfif stObjFormItem.validateRequired is true>
					<cfset validationRule = ListAppend(validationRule,"required:true")>
				</cfif>
				
				<cfswitch expression="#stObjFormItem.validateType#">
					<cfcase value="url">
						<cfset validationRule = ListAppend(validationRule,"url:true")>
					</cfcase>
					<cfcase value="email">
						<cfset validationRule = ListAppend(validationRule,"email:true")>
					</cfcase>
					<cfcase value="date">
						<cfset validationRule = ListAppend(validationRule,"dateDE:true")>
					</cfcase>
					<cfcase value="creditcard">
						<cfset validationRule = ListAppend(validationRule,"creditcard:true")>
					</cfcase>
					<cfcase value="digits">
						<cfset validationRule = ListAppend(validationRule,"digits:true")>
					</cfcase>
					<cfcase value="number">
						<cfset validationRule = ListAppend(validationRule,"numberDE:true")>
					</cfcase>
				</cfswitch>
				
				<cfif IsNumeric(stObjFormItem.validateMinLength)>
					<cfif (stObjFormItem.validateType is "digits") or (stObjFormItem.validateType is "number")>
						<cfset validationRule = ListAppend(validationRule,"minValue:#stObjFormItem.validateMinLength#")>
					<cfelse>
						<cfset validationRule = ListAppend(validationRule,"minLength:#stObjFormItem.validateMinLength#")>
					</cfif>
				</cfif>
				
				<cfif IsNumeric(stObjFormItem.validateMaxLength)>
					<cfif (stObjFormItem.validateType is "digits") or (stObjFormItem.validateType is "number")>
						<cfset validationRule = ListAppend(validationRule,"maxValue:#stObjFormItem.validateMaxLength#")>
					<cfelse>	
						<cfset validationRule = ListAppend(validationRule,"maxLength:#stObjFormItem.validateMaxLength#")>
					</cfif>
				</cfif>
				
			</cfif>
			
								
			<!--- display (or not) label --->
			<cfif not ListFind(noLabel,stObjFormItem.type)>

				<cfoutput><label for="#stObjFormItem.objectid#"></cfoutput>
				<cfif Len(trim(stObjFormItem.title))>
					<cfif stObjFormItem.validateRequired is true>
						<cfoutput><span class="required">#stObjFormItem.title# *</span>:</cfoutput>
					<cfelse>
						<cfoutput>#stObjFormItem.title#:</cfoutput>
					</cfif>
				</cfif>
				
				<cfoutput></label></cfoutput>
						
			</cfif>
			
			<cfif stObjFormItem.type NEQ "hidden" AND stObjFormItem.cssID NEQ "">
				<cfset thisCssID = ' id="#stObjFormItem.cssID#"' />
			<cfelse>
				<cfset thisCssID = "" />
			</cfif>
			
			<!--- Set initial value or if the form has been submitet set the initial value to form item value --->
			<cfif StructKeyExists(form, "#stObjFormItem.objectid#")>
				<cfset initValue = form[stObjFormItem.objectid] />
			<cfelse>
				<cfset initValue = stObjFormItem.initValue />
			</cfif>
			
			<cfswitch expression="#stObjFormItem.type#">
				<cfcase value="textfield">
					 <cfoutput>
					<input name="#stObjFormItem.objectid#" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> type="text" class="<cfif ListLen(validationRule) gt 0>{#validationRule#}</cfif> text" value="#initValue#"#thisCssID# />
					</cfoutput>
				</cfcase>
				<cfcase value="textarea">
					<cfoutput>
					<textarea name="#stObjFormItem.objectid#" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> wrap="virtual"#thisCssID#>#initValue#</textarea>
					</cfoutput>
				</cfcase>
				<cfcase value="checkbox">
					<cfoutput>
					<!--- <input name="#stObjFormItem.name#" type="checkbox" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> class="checkbox" value="#stObjFormItem.initValue#"#thisCssID# <cfif initValue is 1>checked</cfif> /> --->
					<input name="#stObjFormItem.objectid#" type="checkbox" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> class="checkbox" value="X"#thisCssID# <cfif stObjFormItem.initValue is 1>checked</cfif> />
					</cfoutput>
				</cfcase>
				<cfcase value="radiobutton">
					<cfoutput>
					<!--- <input name="#stObjFormItem.name#" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> type="radio" class="radio" value="#stObjFormItem.initValue#"#thisCssID# <cfif initValue is 1>checked</cfif> /> --->
					<input 
						<cfif Trim(stObjFormItem.name) is "">name="#stObjFormItem.objectID#"<cfelse>name="#stObjFormItem.name#"</cfif><!--- TODO: Trond, er denne logikken sjekket? Viktig at den også fungerer slik at det valgt radiobutton huskes på valideringsiden, altså etter submit. --->
						<cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"
						</cfif> type="radio" class="radio" value="#stObjFormItem.objectID#"#thisCssID#
						<cfif structkeyexists(form, stObjFormItem.name) AND form[stObjFormItem.name] EQ stObjFormItem.objectID>
							checked
						<cfelse>
							<cfif stObjFormItem.initValue is 1>checked</cfif>
						</cfif>
					/>
					</cfoutput>
				</cfcase>
				<cfcase value="list">
					<cfoutput>
					<select <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> name="#stObjFormItem.objectid#"#thisCssID#>
					</cfoutput>
					
					<cfloop list="#stObjFormItem.initValue#" index="i">
						<cfoutput>
						<option value="#i#"<cfif initValue EQ i> selected</cfif>>#i#</option>
						</cfoutput>
					</cfloop>
					
					<cfoutput>
					</select>
					</cfoutput>
				</cfcase>
				<cfcase value="filefield">
					<cfoutput>
					<input <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> name="#stObjFormItem.objectid#" type="file" class="file"#thisCssID# />
					</cfoutput>
				</cfcase>
				<cfcase value="statictext">
					<cfoutput>
					<span class="statictext">#stObjFormItem.initValue#</span>
					</cfoutput>
				</cfcase>
				<cfcase value="hidden">
					<cfoutput>
						<cfif Left(stObjFormItem.initValue, "1") is "##" and Right(stObjFormItem.initValue, "1") is "##">
							<cfset thisvalue = #xmlformat(Evaluate(stObjFormItem.initValue))#>
						<cfelse>
							<cfset thisvalue = stObjFormItem.initValue>
						</cfif>
						<input type="hidden" name="#stObjFormItem.objectid#" value="#thisvalue#" />
					</cfoutput>
				</cfcase>
			</cfswitch>
			
			<cfif stObjFormItem.type neq "hidden">
				<cfoutput></fieldset></cfoutput>
				<cfif stObjFormItem.linebreak is 1><cfoutput><div class="clear"></div></cfoutput></cfif>
			</cfif>
				
			</cfloop>
			
			<cfoutput>
				<label for="submitidlform" class="submit">&nbsp;</label>
				<input type="submit" class="submit" name="submitidlform" id="submitidlform" value="#attributes.submittext#" />
			</form>
			<!--- 	
					We use a </form> tag instead of closing the <cf_cfJq_forms> tag due to error due to the FarCry 
					cfoutput placements.
					
					Therefor we must also include some other necasary code (the script bloc bellow).
			  --->
				  <cfif skipValidation eq false>
				  <script type="text/javascript"> 
					<cfif attributes.ajax>
						$(document).ready(function() { 
			    			var options = {
			    				target:'#attributes.target#',
								beforeSubmit: function(){
									$('#attributes.target#').empty();
									<cfif attributes.loadType eq "text">
										$('<span class="attributes.loading_class">#attributes.loadMsg#</span>').appendTo($('#attributes.target#'));
									<cfelseif attributes.loadType eq "img">	
										$('<img class="attributes.loading_class" src="#attributes.loadMsg#"/>').appendTo($('#attributes.target#'));
									</cfif>	
								   }
								};  
			    			$(".#attributes.form_class#").validate({
								<cfif attributes.placeError eq "box">
								errorContainer: $(".messageBox#request.cfjq_form_progress#"),
			  					errorLabelContainer: $(".messageBox#request.cfjq_form_progress# ul"),
			  					wrapper: "li",
								</cfif>
			  					submitHandler: function(form) {
			  						$(form).ajaxSubmit(options);
			  						}
							});
						}); 
						<cfelse>
							$(document).ready(function(){
								<cfif attributes.placeError neq "box">
									$(".#attributes.form_class#").validate()
								<cfelse>
									$(".#attributes.form_class#").validate({
										errorContainer: $(".messageBox#request.cfjq_form_progress#"),
			  							errorLabelContainer: $(".messageBox#request.cfjq_form_progress# ul"),
			  							wrapper: "li"
										});
								</cfif>
							});
					</cfif>
				</script>
				</cfif>
			</cfoutput>
			
			<!--- Close attributes.id div --->
			<cfoutput>
				</div>
			</cfoutput>
		</cfsavecontent>
	</cfif>
<cfelse>
	
	<!--- thistag.ExecutionMode is END --->
	<cfset thistag.GeneratedContent=tagoutput>

</cfif>

<cfsetting enablecfoutputonly="yes" />