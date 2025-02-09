export interface DelayParams {
  id: string
  // 延迟原因
  delayReason: string
  // 延迟时间
  delayTime: string
}

export class DelayParamsModel implements DelayParams {
  id: string = ''
  delayReason: string = ''
  delayTime: string = ''

  constructor(model: DelayParams) {
    this.id = model.id
    this.delayReason = model.delayReason
    this.delayTime = model.delayTime
  }
}