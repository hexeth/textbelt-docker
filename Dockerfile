FROM tarampampam/node:13.1-alpine

LABEL url.docker="https://hub.docker.com/r/hexeth/textbelt-docker" \
      url.github="https://github.com/hexeth/textbelt-docker" \
      image.description="Node Alpine based image of textbelt" \

ENV \
#variables for textbelt
  PORT="9090" \
  DEBUG="true" \
  HOST="imap.gmail.com" \
  MAIL_PORT="587" \
  MAIL_USER="email username" \
  MAIL_PASS="email password" \
  SECURE_CONNECTION="true" \
  FROM="email@emailaddress.com" \
  REALNAME="yourname" \
  MAIL_DEBUG="false"

RUN git clone https://github.com/typpo/textbelt.git

RUN npm --prefix ./textbelt install ./textbelt

RUN touch ~/startup.sh \
  && chmod +x ~/startup.sh

#change textbelt /lib/config.js to support env variables
RUN echo '#!/bin/bash' >> ~/startup.sh  \
  && echo "touch /textbelt/server/torlist" >> ~/startup.sh \
  && echo "sed -i \"s|host: 'smtp.example.com'|host: process.env.HOST|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "sed -i \"s|port: 587|port: process.env.MAIL_PORT|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "sed -i \"s|user: 'user@example.com'|user: process.env.MAIL_USER|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "sed -i \"s|pass: 'example password 1'|pass: process.env.MAIL_PASS|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "sed -i \"s|secureConnection: 'false'|secureConnection: process.env.SECURE_CONNECTION|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "sed -i \"s|Jane Doe|process.env.REALNAME|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "sed -i \"s|jane.doe@example.com|process.env.FROM|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "sed -i \"s|debugEnabled: false|debugEnabled: process.env.MAIL_DEBUG|\" /textbelt/lib/config.js"  >> ~/startup.sh \
  && echo "nodejs /textbelt/server/app.js &" >> ~/startup.sh \
  && echo "trap : TERM INT; (while true; do sleep 1000; done) & wait" >> ~/startup.sh

CMD exec /bin/sh -c "~/startup.sh"

EXPOSE 9090
