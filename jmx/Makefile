JMX_PORT?=1099
RMI_PORT?=1098
DEBUG_PORT?=5005

RUN_OPTS+=-Xdebug -Xrunjdwp:transport=dt_socket,address=$(DEBUG_PORT),server=y,suspend=n
RUN_OPTS+=-Dcom.sun.management.jmxremote=
RUN_OPTS+=-Dcom.sun.management.jmxremote.ssl=false
RUN_OPTS+=-Dcom.sun.management.jmxremote.authenticate=false
RUN_OPTS+=-Dcom.sun.management.jmxremote.port=$(JMX_PORT)
RUN_OPTS+=-Dcom.sun.management.jmxremote.rmi.port=$(RMI_PORT)
RUN_OPTS+=-Dcom.sun.management.jmxremote.local.only=false
