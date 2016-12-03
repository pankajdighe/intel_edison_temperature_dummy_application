import time
import paho.mqtt.client as mqtt
import random
import os
import mraa

mqttc=mqtt.Client()
mqttc.connect("iot.eclipse.org",1883,60)
mqttc.loop_start()

#read temperature gg
def read_temperature_data():
	x=mraa.Aio(1)
	val=x.readFloat()
	print val
	return val

#publish temperature
while 1:
    t=read_temperature_data()
    print "Publishing data"
    device_uuid=os.environ['RESIN_DEVICE_UUID'];
    print device_uuid
    (result,mid)=mqttc.publish("topic/GeneralizedIoT/"+str(device_uuid),t,2)
    time.sleep(1)

mqttc.loop_stop()
mqttc.disconnect()