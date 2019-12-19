import os
from google.cloud import storage

sc_audionews_bucket = os.getenv('SC_AUDIONEWS_BUCKET')
sc = storage.Client()


def check_audio_file_exists(art_filename):
    bucket = sc.bucket(sc_audionews_bucket)
    return storage.Blob(bucket=bucket, name=art_filename).exists(sc)


def upload_audio_file(local_path, audio_filename):
    bucket = sc.bucket(sc_audionews_bucket)
    blob = bucket.blob(audio_filename)
    blob.upload_from_filename(local_path)
    print("[newsapi] INFO Audio file {} was uploaded to bucket {}".format(audio_filename, sc_audionews_bucket))
