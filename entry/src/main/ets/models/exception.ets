import { ImageList } from "."

export interface ExceptionParams {
  // 运输任务id
  transportTaskId: string
  // 异常时间: yyyy-MM-dd HH:mm
  exceptionTime: string
  // 上报异常位置
  exceptionPlace: string
  // 异常类型
  exceptionType: string
  // 异常描述
  exceptionDescribe: string | null
  // 异常图片
  exceptionImagesList: ImageList[] | null
}

export class ExceptionParamsModel implements ExceptionParams {
  transportTaskId: string = ''
  exceptionTime: string = ''
  exceptionPlace: string = ''
  exceptionType: string = ''
  exceptionDescribe: string | null = null
  exceptionImagesList: ImageList[] | null = null

  constructor(model: ExceptionParams) {
    this.transportTaskId = model.transportTaskId
    this.exceptionTime = model.exceptionTime
    this.exceptionPlace = model.exceptionPlace
    this.exceptionType = model.exceptionType
    this.exceptionDescribe = model.exceptionDescribe
    this.exceptionImagesList = model.exceptionImagesList
  }
}

export enum exceptionType {
  engine = "发动机启动困难",
  notOnFire = '不着车',
  oil = "漏油",
  water = '漏水',
  lighting = "照明失灵",
  abnormal = "有异响",
  smoke = "排烟异常",
  temperature = "温度异常",
  other = "其他"
}
