from pythonping import ping
from pyping import pyping
response_list = ping('1.1.1.1', size=40, count=10)
import time

print("Hello there!")
print("Hello there!")
ping('1.1.1.1', verbose=True)
print(response_list.rtt_avg_ms)
time.sleep(10)

print("That's it!")