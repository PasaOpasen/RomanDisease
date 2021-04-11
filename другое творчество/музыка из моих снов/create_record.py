

import soundcard as sc
from scipy.io.wavfile import write
import numpy as np
from pydub import AudioSegment
AudioSegment.converter = 'C:/Program Files/ffmpeg-N-99911-g8f4aec719e-win64-gpl-shared-vulkan/bin/ffmpeg'

from termcolor import colored
import colorama
colorama.init()


def print_on_blue(text, end='\n'):
    return print(colored(text,on_color='on_blue'),end =end)
def print_on_red(text, end='\n'):
    return print(colored(text,on_color='on_red'),end =end)
def print_on_green(text, end='\n'):
    return print(colored(text,on_color='on_green'),end =end)
def print_on_magenta(text, end='\n'):
    return print(colored(text,on_color='on_magenta'),end =end)
def print_on_cyan(text, end='\n'):
    return print(colored(text,on_color='on_cyan'),end =end)
def print_on_yellow(text, end='\n'):
    return print(colored(text,on_color='on_yellow'),end =end)



my_speaker = None
bad_result_message = '!!! BAD RESULT OF RECOGNITION. U CAN TRY AGAIN'


def set_speaker():
    lst = sc.all_microphones(include_loopback=True)
    global my_speaker
    
    if len(lst)==0:
        print(colored('U have no callback-speakers thus u will not be able to recognize messages from speaker',on_color='on_yellow',attrs=['bold']))
        return
    if len(lst)==1:
        print(colored(f'Single speaker {lst[0]} was choosen',on_color='on_yellow',attrs=['bold']))
        my_speaker = lst[0]
        return
    
    print_on_blue('Hello! Please set the correct speaker from list or write 0 to disable speaker recognition:')
    for i, s in enumerate(lst):
        print(f"\t{i+1}) {s}")
    
    while True:
        #res = input(f'Just write the number from {0} to {len(lst)} (0 to disable): ')
        res = '2'
        if res.isdigit():
            number = int(res)
            
            if number == 0:
                print()
                print_on_blue('Speaker recognition was disabled')
                print()
                break
            
            if 1 <= number <= len(lst):
                print()
                print_on_blue(f'Speaker {lst[number-1]} was choosen')
                print()
                my_speaker = lst[number-1] 
                break




def speech_to_text_from_speaker(speaker, time = 300, samplerate = 48000, lang = 'ru-RU'):
    """time is the time in secs, samplerate is the frequency of signal"""
    with speaker.recorder(samplerate=samplerate) as mic:
        print_on_magenta(f'Listen ({time} sec)')
        time_count = int(time/3)
        dt = mic.record(3*samplerate)#(time_count)
        print('Process started')
        for _ in range(time_count):
            t = mic.record(3*samplerate)
            #print(t)
            if t.max() != 0:
                dt = np.vstack((dt, t))
            else:
                break
        dt = np.vstack((np.zeros((3000, 2)),dt))        
        print_on_yellow('Okay. Wait')
        write("record.wav", 
              samplerate, 
              np.int16(dt * (32767/np.max(np.abs(np.array([dt.min(),dt.max()]))))))
    
    AudioSegment.from_wav("record.wav").export("record_mp3.mp3", format="mp3")

    #return speech_to_text_from_wav(lang)


def speech_to_text_from_wav(lang = 'ru', file = 'tmp.wav'):

    # Initialize recognizer class (for recognizing the speech)
    r = sr.Recognizer()
    
    # Reading Audio file as source
    # listening the audio file and store in audio_text variable
    
    with sr.AudioFile(file) as source:
        
        audio_text = r.listen(source)
        
    # recoginize_() method will throw a request error if the API is unreachable, hence using exception handling
        try:
            return r.recognize_google(audio_text, language = lang)
        except Exception as e:
            print(e)
            return bad_result_message



set_speaker()
speech_to_text_from_speaker(my_speaker, time = 500, samplerate = 48000, lang = 'ru-RU')
