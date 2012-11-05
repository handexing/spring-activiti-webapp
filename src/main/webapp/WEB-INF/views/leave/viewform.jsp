<%@ page language="java" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/common/global.jsp"%>
<%@ include file="/common/meta.jsp" %>
<%@ include file="/common/include-base-styles.jsp" %>
<%@ include file="/common/include-jquery-ui-theme.jsp" %>
<title>请假办理</title>
<link href="${ctx }/style/style.css" type="text/css" rel="stylesheet">
<link href="${ctx }/js/common/plugins/jui/extends/timepicker/jquery-ui-timepicker-addon.css" type="text/css" rel="stylesheet" />
<script src="${ctx }/js/common/jquery-1.7.1.js" type="text/javascript"></script>
<script src="${ctx }/js/common/plugins/jui/jquery-ui.min.js" type="text/javascript"></script>
<script src="${ctx }/js/common/plugins/jui/extends/timepicker/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
<script src="${ctx }/js/common/plugins/jui/extends/i18n/jquery-ui-date_time-picker-zh-CN.js" type="text/javascript"></script>
<script type="text/javascript">
$(function() {
	$('#startTime,#endTime').datetimepicker({
        stepMinute: 5
    });
	
	$('#realityStartTime,#realityEndTime').datetimepicker({
        stepMinute: 5
    });
	
	//显示当前节点对应的表单信息
	$('#${activityId }').css("display","inline");
});



/**
 * 完成任务
 * @param {Object} taskId
 */
function complete(taskId, variables) {
	// 转换JSON为字符串
    var keys = "", values = "", types = "";
	if (variables) {
		$.each(variables, function() {
			if (keys != "") {
				keys += ",";
				values += ",";
				types += ",";
			}
			keys += this.key;
			values += this.value;
			types += this.type;
		});
	}
	
	var url="${ctx}/leave/task/"+taskId+"/complete";
	// 发送任务完成请求
    $.post(url,{
        keys: keys,
        values: values,
        types: types
    },function(data){
    	alert(data=="success"?"执行成功!":"执行失败!");
    	var a = document.createElement('a');
    	a.href='${ctx }/leave/task/list';
    	a.target = 'main';
    	document.body.appendChild(a);
    	a.click();
    });
    
}

//部门经理审核
function deptLeaderAudit(){
	var deptLeaderPass=$('#deptLeaderPass').val();
	var deptauditreason=$('#deptauditreason').val();
	complete('${taskId}',[
		{
			key: 'deptLeaderPass',
			value: deptLeaderPass,
			type: 'B'
		},
		{
			key: 'deptauditreason',
			value: deptauditreason,
			type: 'S'
		}
	]);
}


//人事审批
function hrAudit(){
	var hrauditreason=$('#hrauditreason').val();
	var hrPass=$('#hrPass').val();
	complete('${taskId}',[
		{
			key: 'hrPass',
			value: hrPass,
			type: 'B'
		},
		{
			key: 'hrauditreason',
			value: hrauditreason,
			type: 'S'
		}
	]);
}

//调整申请
function modifyApply(){
	complete('${taskId}', [{
		key: 'reApply',
		value: $('#reApply').val(),
		type: 'B'
	}, {
		key: 'leaveType',
		value: $('#leaveType').val(),
		type: 'S'
	}, {
		key: 'startTime',
		value: $('#startTime').val(),
		type: 'D'
	}, {
		key: 'endTime',
		value: $('#endTime').val(),
		type: 'D'
	}, {
		key: 'reason',
		value: $('#reason').val(),
		type: 'S'
	}]);
}

//销假
function reportBack(){
	var realityStartTime = $('#realityStartTime').val();
	var realityEndTime = $('#realityEndTime').val();
	complete('${taskId}', [{
		key: 'realityStartTime',
		value: realityStartTime,
		type: 'D'
	}, {
		key: 'realityEndTime',
		value: realityEndTime,
		type: 'D'
	}]);
}

</script>
</head>
<body>
<h1>流程办理</h1>
<font color="red">${message }</font>
<!-- 部门经理审批 -->
<div id="deptLeaderAudit" style="display: none;">
<form id="leaveform" method="post" onsubmit="javascript:return false;">
	<fieldset>
		<legend><small>请假办理</small></legend>
		<table width="50%">
		<tr>
			<td align="right">请假类型：</td>
			<td>
				${leave.leaveType }
			</td>
		</tr>
		<tr>
			<td align="right">开始时间：</td>
			<td>
				<fmt:formatDate value="${leave.startTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
		<tr>
			<td align="right">结束时间：</td>
			<td>
				<fmt:formatDate value="${leave.endTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
		<tr>
			<td align="right">请假原因：</td>
			<td>
				${leave.reason }
			</td>
		</tr>
		<tr>
			<td align="right">部门领导审批意见：</td>
			<td>
				<textarea name="deptauditreason" id="deptauditreason"></textarea>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
			<td>
				<select id="deptLeaderPass" name="deptLeaderPass">
					<option value="true">同意</option>
					<option value="false">驳回</option>
				</select>
				<button onclick="deptLeaderAudit();" >提交</button>
			</td>
		</tr>
	</table>
	</fieldset>
</form>
</div>
<!-- 调整申请 -->
<div id="modifyApply" style="display: none;">
<form:form id="leaveform"  method="post" onsubmit="javascript:return false;">
	<fieldset>
		<legend><small>请假办理</small></legend>
		<table width="50%">
		<tr>
			<td align="right">请假类型：</td>
			<td>${leave.leaveType }
				<select id="leaveType" name="leaveType">
					<option>公休</option>
					<option>病假</option>
					<option>调休</option>
					<option>事假</option>
					<option>婚假</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right">开始时间：</td>
			<td>
				<input type="text" id="startTime" name="startTime" value="<fmt:formatDate value="${leave.startTime }" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
			</td>
		</tr>
		<tr>
			<td align="right">结束时间：</td>
			<td>
				<input type="text" id="endTime" name="endTime" value="<fmt:formatDate value="${leave.endTime }" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
			</td>
		</tr>
		<tr>
			<td align="right">请假原因：</td>
			<td>
				<textarea name="reason" id="reason">${leave.reason }</textarea>
			</td>
		</tr>
		<tr>
			<td align="right">部门领导审批意见：</td>
			<td>
				${leave.variables.deptauditreason }
			</td>
		</tr>
		<c:if test="${!empty leave.variables.hrauditreason }">
			<tr>
				<td align="right">人事审批意见：</td>
				<td>
					${leave.variables.hrauditreason }
				</td>
			</tr>
		</c:if>
		<tr>
			<td>
				&nbsp;
			</td>
			<td>
				<select id="reApply" name="reApply">
					<option value="true">重新申请</option>
					<option value="false">结束流程</option>
				</select>
				<button onclick="modifyApply();">提交</button>
			</td>
		</tr>
	</table>
	</fieldset>
</form:form>
</div>
<!-- 人事审批 -->
<div id="hrAudit" style="display: none;">
<form:form id="leaveform"  method="post" onsubmit="javascript:return false;">
	<fieldset>
		<legend><small>请假办理</small></legend>
		<table width="50%">
		<tr>
			<td align="right">请假类型：</td>
			<td>
				${leave.leaveType }
			</td>
		</tr>
		<tr>
			<td align="right">开始时间：</td>
			<td>
				<fmt:formatDate value="${leave.startTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
		<tr>
			<td align="right">结束时间：</td>
			<td>
				<fmt:formatDate value="${leave.endTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
		<tr>
			<td align="right">请假原因：</td>
			<td>
				${leave.reason }
			</td>
		</tr>
		<tr>
			<td align="right">部门领导审批意见：</td>
			<td>
				${leave.variables.deptauditreason }
			</td>
		</tr>
		<tr>
			<td align="right">人事审批意见：</td>
			<td>
				<textarea name="hrauditreason" id="hrauditreason"></textarea>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
			<td>
				<select id="hrPass" name="hrPass">
					<option value="true">同意</option>
					<option value="false">驳回</option>
				</select>
				<button onclick="hrAudit();">提交</button>
			</td>
		</tr>
	</table>
	</fieldset>
</form:form>
</div>
<!-- 销假 -->
<div id="reportBack" style="display: none;">
<form:form id="leaveform"  method="post" onsubmit="javascript:return false;">
	<fieldset>
		<legend><small>请假办理</small></legend>
		<table width="50%">
		<tr>
			<td align="right">请假类型：</td>
			<td>
				${leave.leaveType }
			</td>
		</tr>
		<tr>
			<td align="right">开始时间：</td>
			<td>
				<fmt:formatDate value="${leave.startTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
		<tr>
			<td align="right">结束时间：</td>
			<td>
				<fmt:formatDate value="${leave.endTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
		<tr>
			<td align="right">请假原因：</td>
			<td>
				${leave.reason }
			</td>
		</tr>
		<tr>
			<td align="right">部门领导审批意见：</td>
			<td>
				${leave.variables.deptauditreason }
			</td>
		</tr>
		<c:if test="${!empty leave.variables.hrauditreason }">
			<tr>
				<td align="right">人事审批意见：</td>
				<td>
					${leave.variables.hrauditreason }
				</td>
			</tr>
		</c:if>
		<tr>
			<td align="right">实际开始时间：</td>
			<td>
				<input type="text" id="realityStartTime" name="realityStartTime"/>
			</td>
		</tr>
		<tr>
			<td align="right">实际结束时间：</td>
			<td>
				<input type="text" id="realityEndTime" name="realityEndTime"/>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
			<td>
				<button onclick="reportBack();">提交</button>
			</td>
		</tr>
	</table>
	</fieldset>
</form:form>
</div>
</html>