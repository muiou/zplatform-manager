<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:include page="../../top.jsp"></jsp:include>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
  <body>
  <style type="text/css">
  	table tr td{height:25px}
  	table tr td input{height:15px}
  	table tr td select{height:20px}
  </style>
  	<div style="margin: 5px;border:" id="continer">
	    <div id="p" class="easyui-panel" title="查询条件" style="height:100px;padding:10px;background:#fafafa;"   iconCls="icon-save" collapsible="true">
			<form id="theForm"   method="post" >
			<input type="hidden" id="flag_ins" value="${flag}" />
				<table width="100%">
					<tr>
						<td align="right" width="10%">会员编号</td>
						<td align="left" style="padding-left:5px" width="15%">
							<input  id="merchId_ins" maxlength="15"/>
						</td>
						<td align="right" width="10%">商户名称</td>
						<td align="left" style="padding-left: 5px" width="15%" >
							<input  id="merchName_ins" maxlength="50"/>
						</td>
						<td align="right" width="10%">商户状态</td>
						<td align="left" style="padding-left: 5px" width="15%" >
							<select id="status_ins" class="easyui-validatebox">
						          <option value='00'>在用</option>
						          <option value='10'>注册待初审</option>
						          <option value='11'>注册初审未过</option>
						          <option value='41'>变更复审未过</option>
						          <option value='21'>注册复审未过</option>
						          <option value='20'>注册待复审</option>
						          <option value='30'>变更待初审</option>
						          <option value='40'>变更待复审</option>


						          
 							<!--  <option value='69'>注销审核终止</option>
 								  <option value='60'>注销待复审</option>
 								  <option value='61'>注销复审未过</option>
 								  <option value='51'>注销初审未过</option>
						          <option value='50'>注销待初审</option>
						          <option value='29'>注册审核终止</option>
						          <option value='49'>修改审核终止</option>
						          <option value='19'>商户注册终止</option>
						          <option value='99'>商户归档</option> -->
						          
					        </select>
						</td>
						<td align="right"  width="10%">
							<a href="javascript:search()"  class="easyui-linkbutton" iconCls="icon-search">查询</a>
						</td>
					</tr>
					
				</table>
			</form>
		</div>
		<div style="margin-top: 5px">
			<table id="test"></table>
		</div>
		
	</div>
	
  </body>
  
  <script>
  	var width = $("#continer").width();
		$(function(){
			flag=$('#flag_ins').val();
				$('#test').datagrid({
					title:'商户信息列表',
					iconCls:'icon-save',
					height:600,
					singleSelect:true,
					nowrap: false,
					striped: true,
					url:'pages/merchant/queryMerchMerchantAction.action?flag='+flag,
					remoteSort: false,
				//	idField:'ORGAN_ID',
					columns:[
					[
						{field:'MEMBERID',title:' 会员编号',align:'center',width:120},
						{field:'MERCHNAME',title:'商户名称',width:120,align:'center'},
						{field:'LICENCENO',title:'营业执照号',width:120,align:'center'},
						{field:'CORPORATION',title:'法人名称',width:120,align:'center'}, 
						{field:'CONTACT',title:'联系人',width:120,align:'center'},
						{field:'STATUS',title:'状态',width:100,align:'center',
							formatter:function(value,rec){
								if(value=="00"){
									return "在用";
								}else if(value=="29"){
									return "注册审核终止";
								}else if(value=="49"){
									return "修改审核终止";
								}else if(value=="19"){
									return "商户注册终止";
								}else if(value=="69"){
									return "注销审核终止";
								}else if(value=="99"){
									return "商户归档";
								}else if(value=="41"){
									return "变更复审未过";
								}else if(value=="40"){
									return "变更待复审";
								}else if(value=="31"){
									return "变更待复审";
								}else if(value=="61"){
									return "注销复审未过";
								}else if(value=="21"){
									return "注册复审未过";
								}else if(value=="20"){
									return "注册待复审";
								}else if(value=="30"){
									return "变更待初审";
								}else if(value=="51"){
									return "注销初审未过";
								}else if(value=="50"){
									return "注销待初审";
								}else if(value=="11"){
									return "注册初审未过";
								}else if(value=="10"){
									return "注册待初审";
								}else if(value=="60"){
									return "注销待复审";
								}
						}
							},	
						{field:'DEPT_ID',title:'操作',width:120,align:'center',
						formatter:function(value,rec){
							if(flag=='10'){
								
								if(rec.STATUS=='00'){
									return '<a href="javascript:ToMerchMk('+rec.MEMBERID+')" style="color:blue;margin-left:10px">秘钥下载</a>&nbsp<a href="javascript:ToMerchDetail('+rec.MERCHID+')" style="color:blue;margin-left:10px">详情</a>';
								}else{
									return '<a href="javascript:ToMerchDetail('+rec.MERCHID+')" style="color:blue;margin-left:10px">详情</a>';
								}
							}else if(flag=='2'){
								return '<a href="javascript:ToMerchAudit('+rec.MERCHID+')" style="color:blue;margin-left:10px">审核</a>';
							}else{
								return '<a href="javascript:ToMerchAudit('+rec.MERCHID+')" style="color:blue;margin-left:10px">复核</a>';
							}
							
						}
										}
						
					]],
						pagination:true,
						rownumbers:true
				});
			
			var p = $('#test').datagrid('getPager');
			$.extend($.fn.validatebox.defaults.rules, {   
			    minLength: {   
			        validator: function(value, param){ 
						var re =  /^\d+$/; 
		        		if(!re.test(value)){
							return false;
			        	}  
			            return value.length >= param[0];   
			        },   
			        message: '请输入4位数字的部门代码'  
			    }
			   
			});  
		});
		function search(){
			//var url="pages/merchant/queryMerchMerchantAction.action?flag="+$("#flag").val();
			var data={
					'merchDate.memberid':$('#merchId_ins').val(),
					'merchDate.merchname':$('#merchName_ins').val(),
					'merchDate.status':$('#status_ins').val()
					};
			$('#test').datagrid('load',data);
		}

		function ToMerchDetail(memberId){
			window.location.href= "<%=basePath%>" +'/pages/merchant/ToMerchDetailMerchantAction.action?merchId='+memberId;
			window.event.returnValue = false;
		}
		function ToMerchMk(memberId){
			window.location.href= "<%=basePath%>" +'/pages/merchant/loadMerchMkMerchantAction.action?memberId='+memberId;
	    	window.event.returnValue = false;
            
		}
	
		
	</script>
</html>
