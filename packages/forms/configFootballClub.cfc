<!--- @@Copyright: Copyright (c) 2015 . All rights reserved. --->
<!--- @@License:
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
--->

<!--- @@displayname: configFootballClub.cfc --->
<!--- @@description: There is no description for this template. Please add or remove this message. --->
<!--- @@author: Jørgen M. Skogås (jorgen@amerika.no) on 2015-11-16 --->

<cfcomponent displayname="Form settings (idlform-plugin)" output="false" extends="farcry.core.packages.forms.forms" hint="Settings for the idlform plugin." key="idlform">

	<!--- Properties
	////////////////////////////////////////////////////////////////////////////////////////////////////// --->
				
	<cfproperty ftSeq="33" ftFieldset="Theme settings (js/css)"
				name="settings" type="string" default="uniform"
				ftLabel="Form theme" ftType="list" ftList="uniform:Uniform (tries the project first, then the plugin),none:Don't style my forms'" ftDefault="uniform"
				ftHint="The idlform plugin will default load the plugins theme (UniForm) - http://pixelmatrix.github.io/uniform/" />

</cfcomponent>