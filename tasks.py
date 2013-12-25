from invoke import task, run

BOLD_ON  = "\033[1m"
BOLD_OFF = "\033[21m"

@task
def test(ugen=None):
  print "Testing: {}{}{}".format(BOLD_ON, ugen, BOLD_OFF)
  run("chuck lib/{0} test/{0}_test".format(ugen))
