<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>

<jsp:include page="../../top.jsp"></jsp:include>
<body>
<link href='js/checkboxbeautify/css.css' rel="stylesheet" type="text/css" />
		<style type="text/css">
			#groupinfo {height:25px;}
			#groupinfo tr td{height:25px;border-style:solid;border-width:0px 0px 0px 0px;border-color:#000000;padding:1px}
			#groupinfo tr td input{height:20px;margin-left:3px;}
			#groupinfo tr td span{height:20px;margin-left:3px;}
			
			.activeflag_label{width:90px}
		</style>
	  	<div style="margin: 5px;border:" id="continer">
	    <div id="p" class="easyui-panel" title="查询条件" style="height:100px;padding:10px;background:#fafafa;" iconCls="icon-save" collapsible="true">
			<form action="pages/paradic/queryGroupGrouAction.action" id="searchForm">
				<table width="100%">
					<tr>
						<td align="right">产品代码</td>
						<td align="left" style="padding-left:5px"><input id="code_ins" maxlength="8" /></td>
						<td align="right" >产品名称</td>
						<td align="left" style="padding-left: 5px" width="15%"><input id="name_ins"  maxlength="32"/></td>
					</tr>				
					<tr>
					</tr>	
					<tr>
					    <td align="right"></td>
						<td align="right"></td>
						<td align="right"></td>
						<td style="padding-left: 5px"></td>
						<td align="right" >
							<a href="javascript:search()"  class="easyui-linkbutton" iconCls="icon-search">查询</a>
							<a href="javascript:resize()" class="easyui-linkbutton" iconCls="icon-redo">清空</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div style="margin-top:5px">
			<table id="test">
			</table>
		</div>
	</div>


	
	

	
	<div id="w" class="easyui-window" closed="true" title="My Window"
		iconCls="icon-save" style="width: 800px; height: 70px; padding: 5px;">
		<div class="easyui-layout" fit="true">
			<div region="center" border="false"
				style="padding: 10px; background: #fff; text-align: center">
				<form id="firstTrial"   method="post" action="pages/refund/batchAuditRefundAuditAction.action" >
				<input id="withdraworderno" type="hidden" name="pojoTxnsLog.txnseqno">
				<!--  <input id="falg" type="hidden" name="pojoTxnsLog.flag">-->
				
				</form>
			</div>
			<div region="south" border="false" style="text-align:center;padding:5px 0;">
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:batchTrial(true)" id="btn_submit">通过</a>
				<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:batchTrial(false)"  id="icon-cancel">拒绝</a>
			</div>
		</div>
	</div>

	
</body>

<script>
	$(function() {
		$('#beginDate').datebox();
		$('#endDate').datebox();
		$('#test').datagrid({
			title : '划拨批次审核',
			iconCls : 'icon-save',
			height : 500,
			singleSelect : true,
			nowrap : false,
			striped : true,
			url :'pages/refund/queryTxnsRefundAuditAction.action', 
			remoteSort : false,
			idField : 'ORGAN_ID',
			collapsible:true,
			columns : [ [
					{field : 'ck',checkbox : true},
					{field : 'TXNSEQNO',title : '交易流水号',width : 130,align : 'center'},
					{field : 'totalCount',title : '总笔数',width : 90,align : 'center'},
					{field : 'totalAmt',title : '总金额',width : 90,align : 'center',
						formatter:function(value,rec){
									return value/100.00;
						}},
					{field : 'approveCount',title : '通过笔数',width : 90,align : 'center'},
					{field : 'approveAmt',title : '通过金额',width : 90,align : 'center',
						formatter:function(value,rec){
							return value/100.00;
					}},
					{field : 'refuseCount',title : '拒绝笔数',width : 90,align : 'center'},
					{field : 'refuseAmt',title : '拒绝金额',width : 90,align : 'center',
						formatter:function(value,rec){
							return value/100.00;
					}},
					{field : 'waitApproveCount',title : '待审笔数',width : 90,align : 'center'},
					{field : 'waitApproveAmt',title : '待审金额',width : 90,align : 'center',
						formatter:function(value,rec){
									return value/100.00;
					}},
					{field : 'busiType',title : '业务名称',width : 90,align : 'center',
						formatter : function(value, rec) {
										if (value == '00') {
											return '代付';
										} else if (value == '01') {
											return '提现';
										}else if (value == '02') {
											return '退款';
										}else  {
											return '';
										}
									}
					},
					{field : 'applyTime',title : '申请时间',width : 90,align : 'center'},
					{field : 'approveFinishTime',title : '审核完成时间',width : 90,align : 'center'},
					{field : 'finishTime',title : '转账完成时间',width : 90,align : 'center'},
					{field : 'status',title : '状态',width : 100,align : 'center',
						formatter : function(value, rec) {
										if (value == '01') {
											return '未审核';
										} else if (value == '02') {
											return '部分审核通过';
										} else if (value == '00') {
											return '转账成功';
										} else if (value == '03') {
											return '全部审核通过';
										} else {
											return '';
										}
									} 
					}
					
					] ],
			singleSelect : false,
			selectOnCheck : true,
			checkOnSelect : false,
			pagination : true,
			rownumbers : true,
			toolbar : [ {
				id : 'btnadd',
				text : '批次审核',
				iconCls : 'icon-ok',
				handler : function() {
					var check= $('#test' ).datagrid( 'getChecked');
					if(check.length!=0){
						var myArray="";
	                    for (var i=0;i<check.length;i++){
	                  	   myArray+=check[i].TXNSEQNO+"|"
	                    } 
	                    alert(myArray)
						$("#firstTrial")[0].reset();
						$("#btn_submit").linkbutton('enable');
						$("#icon-cancel").linkbutton('enable');
						$("#withdraworderno").val(myArray);
						showAdd();
					}else{
						$.messager.alert('提示',"请选择数据"); 
						
					}
				}
			
			
			}]
						});
		 
		
		
		$($('#test2').datagrid('getPanel')).panel('collapse',false);
	/* 	$('#test').datagrid('onClickRow', function(index,row){
			alert(index);
		});
 */	});

	function search() {
		var data = {
				"queryTransferBean.batchNo" : $('#batchno').val(),
				"queryTransferBean.beginDate":$("#beginDate").datebox("getValue"),
				"queryTransferBean.endDate":$("#endDate").datebox("getValue")
			   }
			$('#test').datagrid('load', data);
	}

	function showAdd() {
	
		$('#w').window({
			title : '批量审核',
			top : 200,
			width : 300,
			collapsible : false,
			minimizable : false,
			maximizable : false,
			modal : true,
			shadow : false,
			closed : false,
			height : 80,
			left:400
		});
	}

	
	
	
	function closeAdd() {
		$('#ws').window('close');
		$('#wss').window('close');
		$('#w').window('close');
	}

	
	function batchTrial(falg){
		if(falg==true){
			$("#firstTrial").attr("action","pages/refund/batchAuditRefundAuditAction.action");
			$("#falg").val("true");
		}else{
			$("#firstTrial").attr("action","pages/refund/batchAuditRefundAuditAction.action");
			$("#falg").val("false");
		}
		$('#firstTrial').form('submit', {  
		    onSubmit: function(){  
			    if($('#firstTrial').form('validate')){
			    	$('#btn_submit').linkbutton('disable');
					$("#icon-cancel").linkbutton('disable');
					
			    	return 	true;
				}
		        return false;   
		    },   
		    success:function(data){  
		    	$.messager.alert('提示',data); 
    			//search();
	    		closeAdd();
		    }  
		});   
	}
	function singleTrial(falg){
		if(falg==true){
			$("#singleTrial").attr("action","pages/transfer/trailTransferDetaTransferAction.action");
			$("#falg_").val("true");
		}else{
			$("#singleTrial").attr("action","pages/transfer/trailTransferDetaTransferAction.action");
			$("#falg_").val("false");
	
		}
		$('#singleTrial').form('submit', {  
		    onSubmit: function(){  
			    if($('#singleTrial').form('validate')){
			    	$('#btn_submit_').linkbutton('disable');
					$("#icon-cancel_").linkbutton('disable');		
			    	return 	true;
				}
		        return false;   
		    },   
		    success:function(data){  
		    	$.messager.alert('提示',data); 
    			search();
	    		closeAdd();
		    }  
		});   
	}
	
	function getTransfer(tranid){
		var ison=false;
		$.ajax( { 
				type: "POST",
	             url: "pages/transfer/queryTrinsferTransferAction.action",
	             data: {"transQuery.tranId":tranid,"falg":"first"},
	             dataType: "json",
	             async:false,
	             success: function(data){
	            var	json=data.rows[0];
	            if(json==null){
	            	$.messager.alert('提示',"数据不正确，请刷新后重试");	
	            }else{
	            	$("#ttranid").html(json.tranid);
	            	if(json.acctype=="00"){
	                	$("#tacctype").html("对私");
	            	}else if(json.acctype=="01"){
	            		$("#tacctype").html("对公");
	            	}else {
	            		$("#tacctype").html("");
	            	}
	        
	            	$("#taccno").html(json.accno);
	            	$("#taccname").html(json.accname);
	            	$("#tbanktype").html(json.banktype);
	            	$("#tbankname").html(json.bankname);
	            	$("#ttransamt").html(json.money+"元");
	            	$("#tremark").html(json.remark);
	            	$("#tresv").html(json.resv);
	            	
	            		if (json.status == '01') {
	            			$("#tstatus").html("初始");
						} else if (json.status == '02') {
							$("#tstatus").html("划拨中");
						} else if (json.status == '00') {
							$("#tstatus").html("划拨成功");
						} else if (json.status == '03') {
							$("#tstatus").html("划拨失败");
						} else if (json.status == '11') {
							$("#tstatus").html("待初审");
						} else if (json.status == '21') {
							$("#tstatus").html("待复审");
						} else if (json.status == '19') {
							$("#tstatus").html("初审未过");
						} else if (json.status == '29') {
							$("#tstatus").html("复审未过");
						} else {
							return '';
						}
	            	
	            	$("#tbanktranid").html(json.banktranid);
	            	$("#tresptype").html(json.resptype);
	            	$("#trespcode").html(json.respcode);
	            	$("#trespmsg").html(json.respmsg);
	            	$("#ttrandate").html(json.trandate);
	            	$("#ttrantime").html(json.trantime);
	            	$("#trelatedorderno").html(json.relatedorderno);
	            	if(json.busitype=="3000"){
	            		$("#tbusicode").html("提现");
	            	}else if(json.busitype=="7000"){
	            		$("#tbusicode").html("代付");
	            	}
	            	
	            	
	            	$("#tsplitflag").html(json.splitflag);
	            	$("#taccstatus").html(json.accstatus);
	            	$("#taccinfo").html(json.accinfo);
	            	$("#ttransfertype").html(json.transfertype);
	            	$("#tcreatetime").html(json.createtime);
	            	$("#tmemberid").html(json.memberid);
	            	$("#tbusitype").html(json.busitype);
	            	$("#tstexauser").html(json.stexauser);
	            	$("#tstexatime").html(json.stexatime);
	            	$("#tstexaopt").html(json.stexaopt);
	            	$("#tcvlexauser").html(json.cvlexauser);
	            	$("#tcvlexatime").html(json.cvlexatime);
	            	$("#tcvlexaopt").html(json.cvlexaopt);
	            	$("#ttxnseqno").html(json.txnseqno);
	            	$("#ttxnfee").html(json.fee);
	            	$("#withdraworderno").val(json.tranid);
	           isok=true;
	            }
	             }
		})
		if(isok==true){
			$("#btn_submit").linkbutton('enable');
			$("#icon-cancel").linkbutton('enable');
		showAddss();
	
		}
		}
	
	
	function secondTrial(falg){
		
		if(falg==true){

				$("#secondTrial").attr("action",
						"pages/transfer/secondAuditByConditionsTransferAction.action?falg=first");
				$("#falgs").val("true");
				$("#falg").val("true");
				$("#falgss").val("true");
			}else{

					$("#secondTrial").attr("action",
							"pages/transfer/secondAuditByConditionsTransferAction.action?falg=first");
					$("#falgs").val("false");
					$("#falg").val("false");
					$("#falgss").val("false");
		
			}
			$('#secondTrial').form('submit', {  
			    onSubmit: function(){  
				    if($('#secondTrial').form('validate')){
				    	$('#btn_submit').linkbutton('disable');
						$("#icon-cancel").linkbutton('disable');
				    	return 	true;
					}
			        return false;   
			    },   
			    success:function(data){  
			    	$.messager.alert('提示',data); 
	    			search();
		    		closeAdd();
			 
			        
			    }  
			});   
		}
</script>
</html>
