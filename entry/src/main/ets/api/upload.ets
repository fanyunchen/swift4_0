import { request } from "@kit.BasicServicesKit";
import { BASE_URL, TOKEN_KEY } from "../constants";
import { ImageList, ResponseData } from "../models";

// 实现图片上传
export const uploadImage = (context: Context, files: request.File[]) => {
  return new Promise<ImageList[]>(async (resolve, reject) => {
    try {
      let result: ImageList[] = [] // 用于接收上传后的永久地址
      let uploadConfig: request.UploadConfig = {
        url: BASE_URL + '/files/imageUpload',
        header: {
          Authorization: AppStorage.get(TOKEN_KEY) || '',
          'Content-Type': 'multipart/form-data'
        },
        method: 'POST',
        files: files,
        data: []
      }

      // 上传文件
      const task = await request.uploadFile(context, uploadConfig)
      task.on("complete", () => {
        // 上传完成，表示成功
        resolve(result)
      })
      task.on("fail", () => {
        // 上传失败
        reject(new Error('上传失败！'))
      })
      task.on("headerReceive", (header) => {
        if (header["body"]) {
          const res = JSON.parse(header["body"]) as ResponseData<string>
          if (res.code === 200 && res.data !== null) {
            result.push({ url: res.data })
          }
        }
      })

    } catch (err) {
      AlertDialog.show({ message: '上传文件失败' + JSON.stringify(err.message) })
      reject(new Error("上传失败" + err.message))
    }
  })
}