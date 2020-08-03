import speech_recognition as sr
from os import path
import sys

arquivo=sys.argv[1]
AUDIO_FILE = path.join(path.dirname(path.realpath(__file__)), arquivo)
r=sr.Recognizer()
s=''
def ouvir_microfone():
#	with sr.Microphone() as source:
#		print('Say something!')
#		audio=r.listen(source)
	with sr.AudioFile(AUDIO_FILE) as source:
		audio=r.record(source)
	try:
		s=r.recognize_google(audio, language='pt-BR')
		print(s)
	except sr.UnknownValueError:
		print('não entendi P**** nenhuma do audio.')
	except sr.RequestError as e:
		print('erro na biblioteca de transcrição, tururuuuu.'.format(e))
ouvir_microfone()
