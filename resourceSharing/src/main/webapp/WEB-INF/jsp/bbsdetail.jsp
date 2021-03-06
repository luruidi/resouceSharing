<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/css/index.css"/>
	<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
	<script type="application/javascript" src="${pageContext.request.contextPath}/js/xcConfirm.js"></script>
	<script type="application/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
    <style>
        .huifulist{
            display: none;
            padding: 20px;
            margin-left: 200px;
            box-shadow: 0 0 20px rgba(0,0,0,0.5);
        }
    </style>
    <title>论坛</title>
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <!-- 网站主体 -->
    <div id="main">
        <div class="bbs">
			<a class="btn" href="#tiezi">回复</a>
			<hr />
			
			<!-- 原帖 -->
			<div class="floor">
				<div class="lf_1">
					<span>${bbs.notesort}</span>
					<a href="">${bbs.notename}</a>
					<hr/>
				</div>
				<div class="cons">
					${bbs.notecontent}
				</div>
			</div>

			<!-- 回复帖子-->
            <c:forEach items="${list}" var="bbsComment">
                <div class="floor">
                    <div class="lf">
                        <div>
                            ${bbsComment.name}
                        </div>
                        <div>
                            <img src="/headImage/${bbsComment.image}" />
                        </div>
                    </div>
                    <div class="rf">
                        <div>
                            <span>发表于 <fmt:formatDate value="${bbsComment.commenttime}" pattern="yyyy-MM-dd HH:mm:ss"/> </span>
                            <span><%--1楼--%></span>
                        </div>
                        <div class="cts">
                            ${bbsComment.commentcontent}
                        </div>
                        <div>
						<span>
							<a href="javascript:void(0);" >回复</a>
							<input type="text" name="" placeholder="回复内容"/><a id="${bbsComment.id}" onclick="replays(this)">提交</a>
						</span>
                            <span id="${bbsComment.id}" onClick="replay(this)"><a>共${bbsComment.count}条评论，点击查看</a></span>
                        </div>
                    </div>
                </div>
				<div class="huifulist" id="huifu${bbsComment.id}">
                    <c:forEach items="${bbsComment.list}" var="BbsCommentReplyVo">
                        <div class="cts">
                                ${BbsCommentReplyVo.name}:${BbsCommentReplyVo.replycomment}<span>&nbsp;&nbsp;<fmt:formatDate value="${BbsCommentReplyVo.replytime}" pattern="yyyy-MM-dd HH:mm"/> </span>
                        </div>
                    </c:forEach>
					<%--<div class="cts">
						我也记得这个新闻，为楼主的钻研精神点赞~<span>2017/5/9</span>
					</div>
					<div class="cts">
						我也记得这个新闻，为楼主的钻研精神点赞~<span>2017/5/9</span>
					</div>--%>
				</div>
            </c:forEach>

			<div class="panigation">
				<a href="${pageContext.request.contextPath }/BbsController/bbsDetail.action?id=${bbs.id}&&currentPage=1">首页</a>
				<c:forEach begin="1" end="${page.totalPage}" varStatus="loop">
					<a href="${pageContext.request.contextPath }/BbsController/bbsDetail.action?id=${bbs.id}&&currentPage=${loop.index}">${loop.index}</a>
				</c:forEach>
				<a href="${pageContext.request.contextPath }/BbsController/bbsDetail.action?id=${bbs.id}&&currentPage=${page.totalPage}">尾页</a>
			</div>



			<%--<a class="btn" href="#tiezi">发帖</a>
			<hr />--%>

			<!-- 开始发帖-->
			<!-- 上传表单-->
			<div class="bbs_tz" id="tiezi">
				<%--<p>回复</p>--%>
				<hr />
				<form name="bbsCommentForm" action="${pageContext.request.contextPath}/BbsCommentController/saveBbsComment.action?bbsid=${bbs.id}&&userid=${user.id}" method="post">
					<span>
						<textarea  id="commentcontent" name="commentcontent" class="area"></textarea>
					</span>
					<span><a id="reply" class="btn">发表回复</a></span>
				</form>
			</div>
			
		</div>
		
    </div>

    <script>
		$(function () {
            $("#reply").click(function () {
                var commentcontentVal = $("#commentcontent").val();
                if(commentcontentVal==null||commentcontentVal==""){
                    window.wxc.xcConfirm("回复内容不能为空！", window.wxc.xcConfirm.typeEnum.error);
                    return false;
				}
                bbsCommentForm.submit();
            });
        });
		/*function replay(tag){
			console.log($(tag).next());
			$(tag).next().fadeToggle();
		}*/
        function replay(obj) {
            var ids=$(obj).attr('id');
            if($('#huifu'+ids).css('display')=='none'){
                $('#huifu'+ids).show()
            }else{
                $('#huifu'+ids).hide()
            }

        }
        function replays(obj){
            var neirong=$(obj).prev().val();
            if(neirong==null||neirong==""){
                window.wxc.xcConfirm("回复内容不能为空！", window.wxc.xcConfirm.typeEnum.error);
                return false;
            }
            //评论id
            var commentid=$(obj).attr('id');
            $.ajax({
                type:"post",
                url:"${pageContext.request.contextPath}/bbsComentReply/saveBbsCommentReply.action",
                data:"replycomment="+neirong+"&commentid="+commentid+"&userid="+${user.id},
                dataType:"json",
                success:function(data){
                    if(data==true){
                        $(obj).parent().parent().prev().append('<br/>'+neirong);
                    }
                }
            });
        }
	</script>
</body>
</html>