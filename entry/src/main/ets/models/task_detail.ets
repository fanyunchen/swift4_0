export interface ImageList {
  url: string
}

export class ImageListModel implements ImageList {
  url: string = ""

  constructor(model: ImageList) {
    this.url = model.url
  }
}

export interface ExceptionList {
  exceptionTime: string
  exceptionPlace: string
  exceptionType: string
  exceptionDescribe: string
  handleResult: string
  exceptionImagesList: ImageList[]
}

export class ExceptionListModel implements ExceptionList {
  exceptionTime: string = ""
  exceptionPlace: string = ""
  exceptionType: string = ""
  exceptionDescribe: string = ""
  handleResult: string = ""
  exceptionImagesList: ImageList[] = []

  constructor(model: ExceptionList) {
    this.exceptionTime = model.exceptionTime
    this.exceptionPlace = model.exceptionPlace
    this.exceptionType = model.exceptionType
    this.exceptionDescribe = model.exceptionDescribe
    this.exceptionImagesList = model.exceptionImagesList
    this.handleResult = model.handleResult
  }
}

export interface TaskDetailInfo {
  id: string //司机作业单id
  startAgencyId: string //起始机构id
  startProvince: string //起始省份
  startCity: string //起始市区
  startAddress: string //起始机构详细地址
  endAgencyId: string //目的机构id
  endProvince: string //目的省份
  endAddress: string //目的市
  endCity: string //目的机构详细地址
  status: number //作业状态
  driverId: string //司机id
  transportTaskId: string //运输任务id
  startHandoverName: string //提货对接人
  startHandoverPhone: string //提货对接人电话
  finishHandover: string //交付对接人
  finishHandoverPhone: string //交付对接人电话
  planDepartureTime: string | null //计划发车时间
  actualDepartureTime: string //实际发车时间
  planArrivalTime: string | null //计划到达时间
  actualArrivalTime: string //实际到达时间
  licensePlate: string //车牌号码
  driverName: string //司机姓名
  cargoPickUpPictureList: ImageList[] //提货凭证
  cargoPictureList: ImageList[] //提货图片
  deliverPictureList: ImageList[] //回单图片
  certificatePictureList: ImageList[] //回单凭证
  exceptionList: ExceptionList[] //异常
}

export class TaskDetailInfoModel implements TaskDetailInfo {
  id: string = "" //司机作业单id
  startAgencyId: string = "" //起始机构id
  startProvince: string = "" //起始省份
  startCity: string = "" //起始市区
  startAddress: string = "" //起始机构详细地址
  endAgencyId: string = "" //目的机构id
  endProvince: string = "" //目的省份
  endAddress: string = "" //目的市
  endCity: string = "" //目的机构详细地址
  status: number = 0 //作业状态
  driverId: string = "" //司机id
  transportTaskId: string = "" //运输任务id
  startHandoverName: string = "" //提货对接人
  startHandoverPhone: string = "" //提货对接人电话
  finishHandover: string = "" //交付对接人
  finishHandoverPhone: string = "" //交付对接人电话
  planDepartureTime: string | null = null //计划发车时间
  actualDepartureTime: string = "" //实际发车时间
  planArrivalTime: string | null = null //计划到达时间
  actualArrivalTime: string = "" //实际到达时间
  licensePlate: string = "" //车牌号码
  driverName: string = "" //司机姓名
  cargoPickUpPictureList: ImageList[] = [] //提货凭证
  cargoPictureList: ImageList[] = [] //提货图片
  deliverPictureList: ImageList[] = [] //回单图片
  certificatePictureList: ImageList[] = [] //回单凭证
  exceptionList: ExceptionList[] = [] //异常

  constructor(model: TaskDetailInfo) {
    this.id = model.id
    this.startAgencyId = model.startAgencyId
    this.startProvince = model.startProvince
    this.startCity = model.startCity
    this.startAddress = model.startAddress
    this.endAgencyId = model.endAgencyId
    this.endProvince = model.endProvince
    this.endAddress = model.endAddress
    this.endCity = model.endCity
    this.status = model.status
    this.driverId = model.driverId
    this.transportTaskId = model.transportTaskId
    this.startHandoverName = model.startHandoverName
    this.startHandoverPhone = model.startHandoverPhone
    this.finishHandover = model.finishHandover
    this.finishHandoverPhone = model.finishHandoverPhone
    this.planDepartureTime = model.planDepartureTime
    this.actualDepartureTime = model.actualDepartureTime
    this.planArrivalTime = model.planArrivalTime
    this.actualArrivalTime = model.actualArrivalTime
    this.licensePlate = model.licensePlate
    this.driverName = model.driverName
    this.cargoPickUpPictureList = model.cargoPickUpPictureList
    this.cargoPictureList = model.cargoPictureList
    this.deliverPictureList = model.deliverPictureList
    this.certificatePictureList = model.certificatePictureList
    this.exceptionList = model.exceptionList
  }
}