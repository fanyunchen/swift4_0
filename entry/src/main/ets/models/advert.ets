/**
 * 描述广告数据的模型
 */
export class AdvertClass {
  showAd: boolean = false // 显示广告
  adTime: number = 5 // 广告时长
  adUrl?: string = '' // 广告连接
  adImg: ResourceStr = '' // 广告图片
}