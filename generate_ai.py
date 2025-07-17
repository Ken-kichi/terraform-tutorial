from openai import AzureOpenAI
import base64
import requests
from datetime import datetime
import os
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

class GenerateAI:
    def __init__(self):
        credential = DefaultAzureCredential()
        self.client = SecretClient(vault_url="https://kv-ai-founder.vault.azure.net/", credential=credential)

        # 各種APIキーやエンドポイントを環境変数から取得
        self.api_key:str =self.client.get_secret("AZURE-GPT-4o-MINI-API-KEY").value
        self.endpoint:str = self.client.get_secret("AZURE-GPT-4o-MINI-URL").value
        self.img_api_key:str =self.client.get_secret("AZURE-DALL-E-3-API-KEY").value
        self.img_endpoint:str = self.client.get_secret("AZURE-DALL-E-3-URL").value

    # OpenAIのクライアントを作成する
    def get_client(self)->AzureOpenAI:
        client = AzureOpenAI(
            api_version="2024-12-01-preview",
            azure_endpoint=self.endpoint,
            api_key=self.api_key,
        )
        return client

    # ファイルをbase64形式にエンコードする
    def base64_encode(self,file)->str:
        return base64.b64encode(file.read()).decode("utf-8")

    # 画像ファイルの内容をAIで説明文に変換する
    def get_image_description(self,image_path:str,client:AzureOpenAI)->str:
        with open(image_path, "rb") as image_file:
            response = client.chat.completions.create(
                model="imgai0707",
                messages=[
                    {"role": "system", "content": "You are a helpful image captioning assistant."},
                    {"role": "user", "content": [
                        # 画像の内容をできるだけ具体的に説明してもらう
                        {"type": "text", "text": "Please describe the contents of this image as specifically as possible."},
                        {"type": "image_url", "image_url": {
                            "url": f"data:image/jpeg;base64,{self.base64_encode(image_file)}"
                        }}
                    ]}
                ],
                max_tokens=300
            )
            return response.choices[0].message.content

    # 説明文からアニメ風画像生成用のプロンプトを作成する
    def build_anime_prompt(self,description:str)->str:
        return f"{description}, drawn in anime style, soft lighting, vivid colors, Ghibli-inspired"

    # プロンプトを使ってアニメ風画像を生成する
    def generate_anime_image(self,prompt:str)->dict[str,any]:
        headers = {
            "Content-Type": "application/json",
            "api-key": self.img_api_key,
            "Authorization": f"Bearer {self.img_api_key}"
        }

        body = {
            "model": "dall-e-3",
            "prompt": prompt,
            "size": "1792x1024",
            "style": "vivid",
            "quality": "standard",
            "n": 1
        }

        # 画像生成APIにリクエストを送る
        response = requests.post(self.img_endpoint, json=body, headers=headers)

        # ✅ デバッグ用: レスポンス本文の表示
        print(f"Status: {response.status_code}")
        print(f"Response Text: {response.text}")

        if response.status_code == 200:
            # 画像URLを取得して返す
            result = response.json()
            image_url = result["data"][0]["url"]
            return image_url

        # ✅ エラーがあればエラーメッセージを返す
        return {
            "error": {
                "status_code": response.status_code,
                "message": response.text
            }
        }

    # 画像URLから画像をダウンロードしてローカルに保存する
    def save_image(self,image_url:str)->str:
        response = requests.get(image_url)
        if response.status_code == 200:
            if not os.path.exists("static"):
                os.makedirs("static")
            # 保存するファイル名を作成（日時で一意にする）
            file_name = f"static/anime_image_{datetime.now().strftime('%Y%m%d%H%M%S')}.png"
            with open(file_name, "wb") as f:
                f.write(response.content)
            return file_name
        else:
            print(f"Failed to download image: {response.status_code}")

# ここから下はサンプル実行用のコード
def main():
    # GenerateAIクラスのインスタンスを作成
    generate_ai = GenerateAI()
    # OpenAIクライアントを取得
    client = generate_ai.get_client()
    # サンプル画像のパス
    image_path = "static/lloyd-dirks-R1oSj2m-7Ks-unsplash.jpg"

    # # # ステップ1: 画像を説明に変換
    description = generate_ai.get_image_description(
        image_path=image_path,
        client=client,
        )
    print("image description:", description)
    print("----------")

    # # ステップ2: アニメ用プロンプトを作成
    anime_prompt = generate_ai.build_anime_prompt(description)
    print("generated prompt:", anime_prompt)
    print("----------")

    # ステップ3: 可愛い女の子のアニメ画像を生成（サンプルプロンプトを使用）
    anime_image_url = generate_ai.generate_anime_image(
        prompt="A cute anime girl with big sparkling eyes, long flowing hair, wearing a pastel-colored dress, smiling gently, surrounded by soft light and cherry blossoms, in the style of Japanese anime, highly detailed, vibrant colors, Ghibli-inspired"
        )
    print("generated image url:", anime_image_url)
    # ステップ3: 画像説明から作ったプロンプトでも画像を生成
    anime_image_url = generate_ai.generate_anime_image(
        prompt=anime_prompt
        )
    print("generated image url:", anime_image_url)

    # ステップ4: 画像を保存
    save_path = "static/anime_image.png"
    generate_ai.save_image(anime_image_url)
    print(f"saved image: {save_path}")

# このファイルが直接実行された場合のみmain()を呼び出す
if __name__ == "__main__":
    main()
