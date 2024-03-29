<%@ Page Language="C#" %>
<%
    /* ============================================================================== */
    /* =   PAGE : 결제 결과 출력 PAGE                                               = */
    /* = -------------------------------------------------------------------------- = */
    /* =   결제 요청 결과값을 출력하는 페이지입니다.                                = */
    /* = -------------------------------------------------------------------------- = */
    /* =   연동시 오류가 발생하는 경우 아래의 주소로 접속하셔서 확인하시기 바랍니다.= */
    /* =   접속 주소 : http://kcp.co.kr/technique.requestcode.do                    = */
    /* = -------------------------------------------------------------------------- = */
    /* =   Copyright (c)  2016   NHN KCP Inc.   All Rights Reserverd.               = */
    /* ============================================================================== */
%>
<%
  // 지불 정보
  String site_cd          = Request.Form[ "site_cd"        ];      // 사이트 코드
  String req_tx           = Request.Form[ "req_tx"         ];      // 요청 구분(승인/취소)
  String use_pay_method   = Request.Form[ "use_pay_method" ];      // 사용 결제 수단
  String bSucc            = Request.Form[ "bSucc"          ];      // 업체 DB 정상처리 완료 여부
  // 주문 정보
  String amount           = Request.Form[ "amount"         ];      // KCP 실제 거래 금액
  String tno              = Request.Form[ "tno"            ];      // KCP 거래번호
  String ordr_idxx        = Request.Form[ "ordr_idxx"      ];      // 주문번호
  String good_name        = Request.Form[ "good_name"      ];      // 상품명
  String buyr_name        = Request.Form[ "buyr_name"      ];      // 구매자명
  String buyr_tel1        = Request.Form[ "buyr_tel1"      ];      // 구매자 전화번호
  String buyr_tel2        = Request.Form[ "buyr_tel2"      ];      // 구매자 휴대폰번호
  String buyr_mail        = Request.Form[ "buyr_mail"      ];      // 구매자 E-Mail
  // 결과 코드
  String res_cd           = Request.Form[ "res_cd"         ];      // 결과 코드
  String res_msg          = Request.Form[ "res_msg"        ];      // 결과 메시지
  String res_msg_bsucc    = "";
  // 공통
  String app_time         = Request.Form[ "app_time"       ];      // 승인시간 (공통)
  String pnt_issue        = Request.Form[ "pnt_issue"      ];      // 포인트 서비스사
  // 신용카드
  String card_cd          = Request.Form[ "card_cd"        ];      // 카드 코드
  String card_name        = Request.Form[ "card_name"      ];      // 카드명
  String app_no           = Request.Form[ "app_no"         ];      // 승인번호
  String noinf            = Request.Form[ "noinf"          ];      // 무이자 여부
  String quota            = Request.Form[ "quota"          ];      // 할부개월
  String partcanc_yn      = Request.Form[ "partcanc_yn"    ];      // 부분취소 여부
  // 계좌이체
  String bank_name        = Request.Form[ "bank_name"      ];      // 은행명
  String bank_code        = Request.Form[ "bank_code"      ];      // 은행코드
  // 가상계좌
  String bankname         = Request.Form[ "bankname"       ];      // 입금할 은행
  String depositor        = Request.Form[ "depositor"      ];      // 입금할 계좌 예금주
  String account          = Request.Form[ "account"        ];      // 입금할 계좌 번호
  String va_date          = Request.Form[ "va_date"        ];      // 입금마감시간
  // 포인트
  String add_pnt          = Request.Form[ "add_pnt"        ];      // 발생 포인트
  String use_pnt          = Request.Form[ "use_pnt"        ];      // 사용가능 포인트
  String rsv_pnt          = Request.Form[ "rsv_pnt"        ];      // 적립 포인트
  String pnt_app_time     = Request.Form[ "pnt_app_time"   ];      // 승인시간
  String pnt_app_no       = Request.Form[ "pnt_app_no"     ];      // 승인번호
  String pnt_amount       = Request.Form[ "pnt_amount"     ];      // 적립금액 or 사용금액
  // 휴대폰
  String commid           = Request.Form[ "commid"         ];      // 통신사 코드
  String mobile_no        = Request.Form[ "mobile_no"      ];      // 휴대폰 번호
  // 상품권
  String tk_van_code      = Request.Form[ "tk_van_code"    ];      // 발급사 코드
  String tk_app_no        = Request.Form[ "tk_app_no"      ];      // 승인 번호
  // 현금영수증
  String cash_yn          = Request.Form[ "cash_yn"        ];      // 현금 영수증 등록 여부
  String cash_authno      = Request.Form[ "cash_authno"    ];      // 현금 영수증 승인 번호
  String cash_tr_code     = Request.Form[ "cash_tr_code"   ];      // 현금 영수증 발행 구분
  String cash_id_info     = Request.Form[ "cash_id_info"   ];      // 현금 영수증 등록 번호
  String cash_no          = Request.Form[ "cash_no"        ];      // 현금 영수증 거래 번호

    string req_tx_name = "";

    if (req_tx.Equals ("pay"))
    {
        req_tx_name = "지불";
    }
    else if (req_tx.Equals ("mod"))
    {
        req_tx_name = "매입/취소";
    }

    /* ============================================================================== */
    /* =   가맹점 측 DB 처리 실패시 상세 결과 메시지 설정                           = */
    /* = -------------------------------------------------------------------------- = */

    if (req_tx.Equals("pay"))
    {
        // 업체 DB 처리 실패
        if (bSucc.Equals("false"))
        {
            if (res_cd.Equals("0000"))
            {
                res_msg_bsucc = "결제는 정상적으로 이루어졌지만 쇼핑몰에서 결제 결과를 처리하는 중 오류가 발생하여 시스템에서 자동으로 취소 요청을 하였습니다. <br> 쇼핑몰로 전화하여 확인하시기 바랍니다.";
            }
            else
            {
                res_msg_bsucc = "결제는 정상적으로 이루어졌지만 쇼핑몰에서 결제 결과를 처리하는 중 오류가 발생하여 시스템에서 자동으로 취소 요청을 하였으나, <br> <b>취소가 실패 되었습니다.</b><br> 쇼핑몰로 전화하여 확인하시기 바랍니다.";
            }
        }
    }
    /* = -------------------------------------------------------------------------- = */
    /* =   가맹점 측 DB 처리 실패시 상세 결과 메시지 설정 끝                        = */
    /* ============================================================================== */
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>*** NHN KCP [AX-HUB Version] ***</title>
<meta name="viewport" content="width=device-width, user-scalable=1.0, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="css/style.css" rel="stylesheet" type="text/css" id="cssLink"/>
<script type="text/javascript">
  var controlCss = "css/style_mobile.css";
  var isMobile = {
    Android: function() {
      return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
      return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
      return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
      return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
      return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
      return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
  };

  if( isMobile.any() )
    document.getElementById("cssLink").setAttribute("href", controlCss);
</script>
<script type="text/javascript">
  /* 신용카드 영수증 연동 스크립트 */
  /* 실결제시 : "https://admin8.kcp.co.kr/assist/bill.BillActionNew.do?cmd=card_bill&tno=" */
  /* 테스트시 : "https://testadmin8.kcp.co.kr/assist/bill.BillActionNew.do?cmd=card_bill&tno=" */
  function receiptView( tno, ordr_idxx, amount ) 
        {
            receiptWin = "https://admin8.kcp.co.kr/assist/bill.BillActionNew.do?cmd=card_bill&tno=";
            receiptWin += tno + "&";
            receiptWin += "order_no=" + ordr_idxx + "&"; 
            receiptWin += "trade_mony=" + amount ;

            window.open(receiptWin, "", "width=455, height=815"); 
        }

  /* 현금 영수증 */ 
  /* 실결제시 : "https://admin8.kcp.co.kr/assist/bill.BillActionNew.do" */ 
  /* 테스트시 : "https://testadmin8.kcp.co.kr/assist/bill.BillActionNew.do" */   
  function receiptView2( cash_no, ordr_idxx, amount ) 
  {
      receiptWin2 = "https://testadmin8.kcp.co.kr/assist/bill.BillActionNew.do?cmd=cash_bill&cash_no=";
      receiptWin2 += cash_no + "&";             
      receiptWin2 += "order_id="     + ordr_idxx + "&";
      receiptWin2 += "trade_mony="  + amount ;

      window.open(receiptWin2, "", "width=370, height=625"); 
  }

  /* 가상 계좌 모의입금 페이지 호출 */
  /* 테스트시에만 사용가능 */
  /* 실결제시 해당 스크립트 주석처리 */
  function receiptView3() 
  {
    receiptWin3 = "http://devadmin.kcp.co.kr/Modules/Noti/TEST_Vcnt_Noti.jsp"; 
    window.open(receiptWin3, "", "width=520, height=300"); 
  }
</script>
</head>
<body>
<form name="cancel" method="post">
<div id="sample_wrap">
  <!--타이틀-->
  <h1>[결과출력] <span>이 페이지는 결제 결과를 출력하는 샘플(예시) 페이지입니다.</span></h1>
  <!--//타이틀-->
  <div class="sample">
    <!--상단문구-->
    <p>
      요청 결과를 출력하는 페이지 입니다.<br />
      요청이 정상적으로 처리된 경우 결과코드(res_cd)값이 0000으로 표시됩니다.
    </p>
    <!--//상단문구-->

<%
    /* ============================================================================== */
    /* =   결제 결과 코드 및 메시지 출력(결과페이지에 반드시 출력해주시기 바랍니다.)= */
    /* = -------------------------------------------------------------------------- = */
    /* =   결제 정상 : res_cd값이 0000으로 설정됩니다.                              = */
    /* =   결제 실패 : res_cd값이 0000이외의 값으로 설정됩니다.                     = */
    /* = -------------------------------------------------------------------------- = */
%>
                    <h2>&sdot; 처리 결과</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                        <!-- 결과 코드 -->
                        <tr>
                          <th>결과 코드</th>
                          <td><%=res_cd%></td>
                        </tr>
                              <!-- 결과 메시지 -->
                        <tr>
                          <th>결과 메세지</th>
                          <td><%=res_msg%></td>
                        </tr>
<%
    // 처리 페이지(pp_cli_hub.aspx)에서 가맹점 DB처리 작업이 실패한 경우 상세메시지를 출력합니다.
    if( !"".Equals ( res_msg_bsucc ) )
    {
%>
                         <tr>
                           <th>결과 상세 메세지</th>
                           <td><%=res_msg_bsucc%></td>
                         </tr>
<%
    }
%>
                    </table>
<%
    /* = -------------------------------------------------------------------------- = */
    /* =   결제 결과 코드 및 메시지 출력 끝                                         = */
    /* ============================================================================== */
%>

<%
    /* ============================================================================== */
    /* =   01. 결제 결과 출력                                                       = */
    /* = -------------------------------------------------------------------------- = */
    if ( "pay".Equals ( req_tx ) )
    {
        /* ============================================================================== */
        /* =   01-1. 업체 DB 처리 정상(bSucc값이 false가 아닌 경우)                     = */
        /* = -------------------------------------------------------------------------- = */
        if ( ! "false".Equals ( bSucc ) )
        {
            /* ============================================================================== */
            /* =   01-1-1. 정상 결제시 결제 결과 출력 ( res_cd값이 0000인 경우)             = */
            /* = -------------------------------------------------------------------------- = */
            if ( "0000".Equals ( res_cd ) )
            {
%>
                    <h2>&sdot; 주문 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                        <!-- 주문번호 -->
                        <tr>
                          <th>주문 번호</th>
                          <td><%= ordr_idxx %></td>
                        </tr>
                        <!-- KCP 거래번호 -->
                        <tr>
                          <th>KCP 거래번호</th>
                          <td><%= tno %></td>
                        </tr>
                        <!-- KCP 실제 거래 금액 -->
                        <tr>
                          <th>결제 금액</th>
                          <td><%= amount %>원</td>
                        </tr>
                        <!-- 상품명(good_name) -->
                        <tr>
                          <th>상 품 명</th>
                          <td><%= good_name %></td>
                        </tr>
                        <!-- 주문자명 -->
                        <tr>
                          <th>주문자명</th>
                          <td><%= buyr_name %></td>
                        </tr>
                        <!-- 주문자 전화번호 -->
                        <tr>
                          <th>주문자 전화번호</th>
                          <td><%= buyr_tel1 %></td>
                        </tr>
                        <!-- 주문자 휴대폰번호 -->
                        <tr>
                          <th>주문자 휴대폰번호</th>
                          <td><%= buyr_tel2 %></td>
                        </tr>
                        <!-- 주문자 E-mail -->
                        <tr>
                          <th>주문자 E-mail</th>
                          <td><%= buyr_mail %></td>
                        </tr>
                    </table>
<%
                /* ============================================================================== */
                /* =   신용카드 결제 결과 출력                                                  = */
                /* = -------------------------------------------------------------------------- = */
                if ( use_pay_method.Equals("100000000000") )
                {
%>
                    <h2>&sdot; 신용카드 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                        <!-- 결제수단 : 신용카드 -->
                        <tr>
                          <th>결제 수단</th>
                          <td>신용 카드</td>
                        </tr>
                        <!-- 결제 카드 -->
                        <tr>
                          <th>결제 카드</th>
                          <td><%= card_cd %> / <%= card_name %></td>
                        </tr>
                        <!-- 승인시간 -->
                        <tr>
                          <th>승인 시간</th>
                          <td><%= app_time %></td>
                        </tr>
                        <!-- 승인번호 -->
                        <tr>
                          <th>승인 번호</th>
                          <td><%= app_no %></td>
                        </tr>
                        <!-- 할부개월 -->
                        <tr>
                          <th>할부 개월</th>
                          <td><%= quota %></td>
                        </tr>
                        <!-- 무이자 여부 -->
                        <tr>
                          <th>무이자 여부</th>
                          <td><%= noinf %></td>
                        </tr>
<%
                    /* ============================================================================== */
                    /* =   신용카드 영수증 출력                                                     = */
                    /* = -------------------------------------------------------------------------- = */
                    /* =   실제 거래건에 대해서 영수증을 출력할 수 있습니다.                        = */
                    /* = -------------------------------------------------------------------------- = */
%>
                    <tr>
                        <th>영수증 확인</th>
                        <td class="sub_content1"><a href="javascript:receiptView('<%=tno%>','<%= ordr_idxx %>','<%= amount %>')"><img src="../sample/img/btn_receipt.png" alt="영수증을 확인합니다." />
                    </td>
                    </tr>
                    </table>
<%              }
                /* ============================================================================== */
                /* =   계좌이체 결제 결과 출력                                                  = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.Equals("010000000000") )
                {
%>
                    <h2>&sdot; 계좌이체 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                    <!-- 결제수단 : 계좌이체 -->
                        <tr>
                          <th>결제 수단</th>
                          <td>계좌이체</td>
                        </tr>
                    <!-- 이체 은행 -->
                        <tr>
                          <th>이체 은행</th>
                          <td><%= bank_name %></td>
                        </tr>
                    <!-- 이체 은행 코드 -->
                        <tr>
                          <th>이체 은행코드</th>
                          <td><%= bank_code %></td>
                        </tr>
                    <!-- 승인시간 -->
                        <tr>
                          <th>승인 시간</th>
                          <td><%= app_time %></td>
                        </tr>
                    </table>
<%
                }
                /* ============================================================================== */
                /* =   가상계좌 결제 결과 출력                                                  = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.Equals("001000000000") )
                {
%>
                    <h2>&sdot; 가상계좌 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                    <!-- 결제수단 : 가상계좌 -->
                        <tr>
                          <th>결제 수단</th>
                          <td>가상계좌</td>
                        </tr>
                    <!-- 입금은행 -->
                        <tr>
                          <th>입금 은행</th>
                          <td><%= bankname %></td>
                        </tr>
                    <!-- 입금계좌 예금주 -->
                        <tr>
                          <th>입금할 계좌 예금주</th>
                          <td><%= depositor %></td>
                        </tr>
                    <!-- 입금계좌 번호 -->
                        <tr>
                          <th>입금할 계좌 번호</th>
                          <td><%= account %></td>
                        </tr>
                    <!-- 가상계좌 입금마감시간 -->
                        <tr>
                          <th>가상계좌 입금마감시간</th>
                          <td><%= va_date %></td>
                        </tr>
                    <!-- 가상계좌 모의입금(테스트시) -->
                        <tr>
                          <th>가상계좌 모의입금</br>(테스트시 사용)</th>
                          <td class="sub_content1"><a href="javascript:receiptView3()"><img src="./css/btn_vcn.png" alt="모의입금 페이지로 이동합니다." />
                        </tr>
                    </table>
<%
                }
                /* ============================================================================== */
                /* =   포인트 결제 결과 출력                                                    = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.Equals("000100000000"))       
                {
%>
                    <h2>&sdot; 포인트 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                    <!-- 결제수단 : 포인트 -->
                        <tr>
                          <th>결제수단</th>
                          <td>포 인 트</td>
                        </tr>
                    <!-- 포인트사 -->
                        <tr>
                          <th>포인트사</th>
                          <td><%= pnt_issue %></td>
                        </tr>
                    <!-- 포인트 승인시간 -->
                        <tr>
                          <th>포인트 승인시간</th>
                          <td><%= pnt_app_time %></td>
                        </tr>
                    <!-- 포인트 승인번호 -->
                        <tr>
                          <th>포인트 승인번호</th>
                          <td><%= pnt_app_no %></td>
                        </tr>
                    <!-- 적립금액 or 사용금액 -->
                        <tr>
                          <th>적립금액 or 사용금액</th>
                          <td><%= pnt_amount %></td>
                        </tr>
                    <!-- 발생 포인트 -->
                        <tr>
                          <th>발생 포인트</th>
                          <td><%= add_pnt %></td>
                        </tr>
                    <!-- 사용가능 포인트 -->
                        <tr>
                          <th>사용가능 포인트</th>
                          <td><%= use_pnt %></td>
                        </tr>
                    <!-- 총 누적 포인트 -->
                        <tr>
                          <th>총 누적 포인트</th>
                          <td><%= rsv_pnt %></td>
                        </tr>
                </table>
<%
                }
                /* ============================================================================== */
                /* =   휴대폰 결제 결과 출력                                                    = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.Equals("000010000000"))
                {
%>
                    <h2>&sdot; 휴대폰 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                    <!-- 결제수단 : 휴대폰 -->
                        <tr>
                          <th>결제 수단</th>
                          <td>휴 대 폰</td>
                        </tr>
                    <!-- 승인시간 -->
                        <tr>
                          <th>승인 시간</th>
                          <td><%= app_time %></td>
                        </tr>
                    <!-- 통신사코드 -->
                        <tr>
                          <th>통신사 코드</th>
                          <td><%= commid %></td>
                        </tr>
                    <!-- 승인시간 -->
                        <tr>
                          <th>휴대폰 번호</th>
                          <td><%= mobile_no %></td>
                        </tr>
                </table>
<%
                }
                /* ============================================================================== */
                /* =   상품권 결제 결과 출력                                                    = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.Equals("000000001000"))
                {
%>
                    <h2>&sdot; 상품권 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                    <!-- 결제수단 : 상품권 -->
                        <tr>
                          <th>결제 수단</th>
                          <td>상 품 권</td>
                        </tr>
                    <!-- 발급사 코드 -->
                        <tr>
                          <th>발급사 코드</th>
                          <td><%= tk_van_code %></td>
                        </tr>
                    <!-- 승인시간 -->
                        <tr>
                          <th>승인 시간</th>
                          <td><%= app_time %></td>
                        </tr>
                    <!-- 승인번호 -->
                        <tr>
                          <th>승인 번호</th>
                          <td><%= tk_app_no %></td>
                        </tr>
                </table>
<%
                }
                /* ============================================================================== */
                /* =   현금영수증 정보 출력                                                     = */
                /* = -------------------------------------------------------------------------- = */
                if( !"".Equals ( cash_yn ) )
                {
%>
                <!-- 현금영수증 정보 출력-->
                    <h2>&sdot; 현금영수증 정보</h2>
                    <table class="tbl" cellpadding="0" cellspacing="0">
                        <tr>
                          <th>현금영수증 등록여부</th>
                          <td><%= cash_yn %></td>
                        </tr>
<%
                    //현금영수증이 등록된 경우 승인번호 값이 존재
                    if( !"".Equals ( cash_authno ) )
                    {
%>
                        <tr>
                          <th>현금영수증 승인번호</th>
                          <td><%= cash_authno %></td>
                        </tr>
                        <tr>
                          <th>현금영수증 거래번호</th>
                          <td><%= cash_no %></td>
                        </tr>
                    <tr>
                        <th>영수증 확인</th>
                        <td class="sub_content1"><a href="javascript:receiptView2('<%= cash_no %>', '<%= ordr_idxx %>', '<%= amount %>' )"><img src="./img/btn_receipt.png" alt="현금영수증을  확인합니다." />
                    </td>
<%
                    }

%>
                  </table>
<%
                }
            }
            /* = -------------------------------------------------------------------------- = */
            /* =   01-1-1. 정상 결제시 결제 결과 출력 END                                   = */
            /* ============================================================================== */
        }
        /* = -------------------------------------------------------------------------- = */
        /* =   01-1. 업체 DB 처리 정상 END                                              = */
        /* ============================================================================== */
    }
    /* = -------------------------------------------------------------------------- = */
    /* =   01. 결제 결과 출력 END                                                   = */
    /* ============================================================================== */
%>
                    <!-- 취소 요청/처음으로 이미지 버튼 -->
                <tr>

                <div class="btnset">
                <a href="../../Default.aspx" class="home">처음으로</a>
                </div>
                </tr>
              </tr>
            </div>
        <div class="footer">
                Copyright (c) NHN KCP INC. All Rights reserved.
        </div>
    </div>
  </body>
</html>