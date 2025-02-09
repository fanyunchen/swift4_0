import { ImageList } from ".";

export interface DeliverParams {
  id: string,
  deliverPictureList: ImageList[],
  certificatePictureList: ImageList[]
}

export class DeliverParamsModel implements DeliverParams {
  id: string = ''
  deliverPictureList: ImageList[] = []
  certificatePictureList: ImageList[] = []

  constructor(model: DeliverParams) {
    this.id = model.id
    this.deliverPictureList = model.deliverPictureList
    this.certificatePictureList = model.certificatePictureList
  }
}