import streamlit as st
from generate_ai import GenerateAI
import os
import tempfile
from PIL import Image

# アプリのタイトルを表示
st.title("Image to Anime Style")

# 画像アップロード用のUIを表示（jpg, jpeg, png形式に対応）
uploaded_file = st.file_uploader("Upload an image",type=["jpg", "jpeg", "png"])

# 画像がアップロードされた場合の処理
if uploaded_file:
    # アップロードされた画像をPILで開く
    image = Image.open(uploaded_file)
    # タブを2つ作成（アニメ風画像と元画像を切り替え表示できる）
    tab1,tab2 = st.tabs(["Anime Style","Original"])
    # 元画像を「Original」タブに表示
    tab2.image(image,use_container_width=True)

    # 一時ファイルとして画像を保存（AIに渡すため）
    with tempfile.NamedTemporaryFile(delete=False, suffix=".png") as tmp_file:
        tmp_file.write(uploaded_file.getbuffer())
        tmp_file_path = tmp_file.name

    # 画像生成AIのインスタンスを作成
    generate_ai = GenerateAI()
    # OpenAIクライアントを取得
    client = generate_ai.get_client()

    # 画像処理中はスピナーを表示
    with st.spinner("画像を読み込んでいます..."):
        # 一時ファイルの画像から内容説明文をAIで生成
        description = generate_ai.get_image_description(
            image_path=tmp_file_path,
            client=client,
        )

        # 説明文からアニメ風画像生成用のプロンプトを作成
        anime_prompt = generate_ai.build_anime_prompt(description)

        # プロンプトを使ってアニメ風画像を生成
        anime_image_url = generate_ai.generate_anime_image(
            prompt=anime_prompt
        )

        # 生成された画像をローカルに保存し、保存先パスを取得
        image_path = generate_ai.save_image(anime_image_url)

        # 生成画像のパスをセッションに保存（再生成を防ぐため）
        st.session_state["anime_image_path"] = image_path

        # 画像が正しく保存されていれば「Anime Style」タブに表示
        if image_path and os.path.exists(image_path):
            tab1.image(image_path, use_container_width=True)
            st.success("画像生成が完了しました！")
        else:
            st.info("まだ画像が生成されていません。")
