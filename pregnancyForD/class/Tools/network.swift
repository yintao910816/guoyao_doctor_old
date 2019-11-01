//
//  network.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation    //罗延琼


let HTTP_RESULT_SERVER_ERROR = "服务器出错！"
let HTTP_RESULT_NETWORK_ERROR = "网络出错，请检查网络连接！"


let HTTP_ROOT_URL = "http://106.14.15.151:8081/doctor-api/"
//let HTTP_ROOT_URL = "https://www.ivfcn.com"

//查询是否是组员    弃用
let HC_IS_MEMBER = HTTP_ROOT_URL + "/app/doctor/queryTeamMember.do"
// 在线咨询列表   弃用
let CONSULT_LIST_URL = HTTP_ROOT_URL + "/app/doctor/consult/getConsultList.do"
// 获取回复列表      弃用
let FIND_PATIENT_REPLYS = HTTP_ROOT_URL + "/app/doctor/findPatientReplys.do"
// 患者列表    弃用
let PATIENTLIST_URL = HTTP_ROOT_URL + "/app/doctor/consult/getPatientList.do"
// 获取医生信息   弃用
let USER_INFO_URL = HTTP_ROOT_URL + "/app/doctor/userInfo.do"
// 更新患者信息     弃用
//let UPDATE_INFO_URL = HTTP_ROOT_URL + "/app/doctor/updateinfo.do"
//获取患者token     弃用
//let HC_GET_PATI_TOKEN = "http://wx.ivfcn.com/doctor/docToPatient"
let HC_GET_PATI_TOKEN = "http://106.14.15.151:8081/doctor-api/doctor/docToPatient"

// 上传接口   并回复
//let USER_FILE_UPLOAD = "https://www.ivfcn.com/app/attach/upload.do"
let USER_FILE_UPLOAD = "http://106.14.15.151:8081/doctor-api/app/attach/upload.do"

// 图片地址  佳音是全地址
//let IMAGE_URL = "https://www.ivfcn.com"
let IMAGE_URL = "http://106.14.15.151:8081"










// 上传接口
//let HC_FILE_UPLOAD = "http://124.88.84.107:8085/common-file/api/fileUpload/singleImg"
//let HC_FILE_UPLOAD = "http://106.14.15.151:8081/doctor-api/common-file/api/fileUpload/singleImg"
let HC_FILE_UPLOAD = "http://106.14.15.151:8086/common-file/api/fileUpload/singleImg"




// 接口根路径
//let JY_ROOT_URL = "http://124.88.84.107:8082/doctor-api/"

//let JY_ROOT_URL = "http://192.168.0.115:8087/doctor-api/"

//let JY_ROOT_URL = "http://app.jyyy.so:8082/doctor-api/"
let JY_ROOT_URL = "http://106.14.15.151:8081/doctor-api/"

/**
 http://106.14.15.151:8081/doctor-api/api/doctor/login?phone=13995631675&code=8888&deviceType=1&deviceInfo=2
 */


let HC_FUNCTION_LIST = JY_ROOT_URL + "api/doctor/index/functionList"
let HC_BANNER_LIST = JY_ROOT_URL + "api/doctor/index/bannerList"
let HC_DYNAMIC_LIST = JY_ROOT_URL + "api/doctor/index/dynamicList"
let HC_CLICK_COUNT = JY_ROOT_URL + "api/doctor/sysApplication/addClickCount/"
let HC_FIND_PATIENT =  JY_ROOT_URL + "api/doctor/cycleMedicalHistory/getPatientsByName"
// 登录
let USER_VALIFY_SMS_URL = JY_ROOT_URL + "api/doctor/login"
//咨询列表
let HC_CONSULT_LIST = JY_ROOT_URL + "api/doctor/consult/getPatientConsultList"
//咨询详情
let HC_CONSULT_DETAIL = JY_ROOT_URL + "api/doctor/consult/getConsultDetailsByPId"
//患者列表
let HC_PATIENT_LIST = JY_ROOT_URL + "api/doctor/consult/getConsultsPatientList"
//更新医生信息
let UPDATE_DOCTOR_INFO = JY_ROOT_URL + "api/doctor/updateinfo"
//获取医生信息
let DOCTOR_INFO_URL = JY_ROOT_URL + "api/doctor/userInfo"
// 拒绝提问    隐藏
let DOCTOR_REJECT = JY_ROOT_URL + "api/doctor/doctorReject"
// 回复文字
let CONSULT_REPLY = JY_ROOT_URL + "api/doctor/consult/consultedReply"
// 咨询模板操作信息
let CONSULT_TEMPLATE_URL = JY_ROOT_URL + "api/doctor/consult/consultTemplateOperation"
// 分组信息
let TAGS_OPERATION_URL = JY_ROOT_URL + "api/doctor/consult/tagsOperation"
//查询是否打开更新提示
let UPDATE_LOCK = JY_ROOT_URL + "api/doctor/consult/validateVersionInfo"
// 当前未回复数量
let NOTREPLY_COUNT_URL = JY_ROOT_URL + "api/doctor/consult/getAllUnReplyCount"
//加锁咨询状态
let UPDATE_CONSULT_STATUS = JY_ROOT_URL + "api/doctor/consult/updateConsultStatus"
//解绑状态
let UNLOCK_CONSULT_STATUS = JY_ROOT_URL + "api/doctor/consult/unlockConsultStatus"
// 更新患者信息
let UPDATE_PATIENT_INFO_URL = JY_ROOT_URL + "api/doctor/consult/updatePatientInfo"
// 患者详情
let PATIENT_INFO_URL = JY_ROOT_URL + "api/doctor/consult/getPatientInfo"
// 获取验证码
let USER_SEND_SMS_URL = JY_ROOT_URL + "api/doctor/validateCode"


//H5界面地址  keyCode
let HC_HREF_H5 = JY_ROOT_URL + "api/doctor/index/hrefH5"


