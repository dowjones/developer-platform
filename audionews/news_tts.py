from datetime import datetime
from google.cloud import texttospeech


def generate_audio_file(article_item, local_path, audio_filename):
    ttsc = texttospeech.TextToSpeechClient()

    text2syn_dt = datetime.fromtimestamp(article_item['publication_datetime'] / 1000).strftime('%d-%m-%Y')
    text2syn_pre = 'This audio reader article is provided to you by Dow Jones. \n\
                    Generated within the audio news reader demo application.'
    text2syn_head = 'Published on <say-as interpret-as="date" format="dd-mm-yyyy \
                     detail="1">{}</say-as> by {}'.format(text2syn_dt, article_item['publisher_name'])
    text2syn_title = article_item['title']
    text2syn_body = article_item['body']
    text2syn_post = 'End of the Audio Article.'

    text2syn_full = '<speak>{} <break time="2s"/> {} <break time="2s"/> {} <break time="2s"/> {} <break time="3s"/>\
                     {}</speak>'.format(text2syn_pre, text2syn_head, text2syn_title, text2syn_body, text2syn_post)

    synthesis_input = texttospeech.types.SynthesisInput(ssml=text2syn_full)
    voice = texttospeech.types.VoiceSelectionParams(
        language_code='en-US',
        ssml_gender=texttospeech.enums.SsmlVoiceGender.NEUTRAL)
    audio_config = texttospeech.types.AudioConfig(
        audio_encoding=texttospeech.enums.AudioEncoding.MP3)
    response = ttsc.synthesize_speech(synthesis_input, voice, audio_config)

    print("INFO Speech-to-Text API response received")
    with open(local_path, 'wb') as out:
        out.write(response.audio_content)
    print("INFO Audio file {} was copied locally".format(audio_filename))

    return audio_filename
