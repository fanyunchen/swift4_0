import { ImageList } from "."

export interface CarRecordParams {
  id: string // 运输id
  // 出车时间   yyyy-MM-dd HH:mm:ss
  startTime: string
  // 回车时间
  endTime: string
  // 事故说明,类型为其他 时填写
  accidentDescription: string | null
  // 事故图片
  accidentImagesList: ImageList[] | null
  // 事故类型:1-直行事故,2-追尾事故,3-超车事故,4-左转弯事故,5-右转弯事故,6-弯道事故,7-坡道事故,8-会车事故,9-其他
  accidentType: string | null
  // 违章说明
  breakRulesDescription: string | null
  // 违章类型:1-闯红灯，2-无证驾驶，3-超载，4-酒后驾驶，5-超速行驶，6-其他，可用
  breakRulesType: string | null
  // 扣分数据
  deductPoints: number | null
  // 故障说明
  faultDescription: string | null
  // 故障图片
  faultImagesList: ImageList[] | null
  // 故障类型:1-发动机启动困难，2-不着车，3-漏油，4-漏水，5-照明失灵，6-有异响，7-排烟异常，8-温度异常，9-其他，可用
  faultType: string | null
  // 是否出现事故
  isAccident: boolean | null
  // 车辆是否可用
  isAvailable: boolean | null
  // 是否违章
  isBreakRules: boolean | null
  // 是否故障
  isFault: boolean | null
  // 罚款金额
  penaltyAmount: string | null
}

export class CarRecordParamsModel implements CarRecordParams {
  id: string = ""
  startTime: string = ""
  endTime: string = ""
  accidentDescription: string | null = null
  accidentImagesList: ImageList[] | null = null
  accidentType: string | null = null
  breakRulesDescription: string | null = null
  breakRulesType: string | null = null
  deductPoints: number | null = null
  faultDescription: string | null = null
  faultImagesList: ImageList[] | null = null
  faultType: string | null = null
  isAccident: boolean | null = null
  isAvailable: boolean | null = null
  isBreakRules: boolean | null = null
  isFault: boolean | null = null
  penaltyAmount: string | null = null

  constructor(model: CarRecordParams) {
    this.id = model.id
    this.startTime = model.startTime
    this.endTime = model.endTime
    this.accidentDescription = model.accidentDescription
    this.accidentImagesList = model.accidentImagesList
    this.accidentType = model.accidentType
    this.breakRulesDescription = model.breakRulesDescription
    this.breakRulesType = model.breakRulesType
    this.deductPoints = model.deductPoints
    this.faultDescription = model.faultDescription
    this.faultImagesList = model.faultImagesList
    this.faultType = model.faultType
    this.isAccident = model.isAccident
    this.isAvailable = model.isAvailable
    this.isBreakRules = model.isBreakRules
    this.isFault = model.isFault
    this.penaltyAmount = model.penaltyAmount
  }
}