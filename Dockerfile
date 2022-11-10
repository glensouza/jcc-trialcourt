FROM devopswebcourtsnp.azurecr.io/drupal-nginx-fpm:1.4

ARG GIT_REPO="https://github.com/judicialcouncilcalifornia/trialcourt.git"
ENV GIT_REPO=$GIT_REPO
ARG GIT_BRANCH="master"
ENV GIT_BRANCH=$GIT_BRANCH

RUN rm -rf ${DRUPAL_BUILD}
RUN mkdir -p ${DRUPAL_BUILD}

RUN git clone ${GIT_REPO} --branch ${GIT_BRANCH} repobuild
RUN rm -rf repobuild/.git
RUN cp -R repobuild/* ${DRUPAL_BUILD}/
RUN rm -rf repobuild

WORKDIR ${DRUPAL_BUILD}
RUN composer install
RUN scripts/theme.sh -i jcc_deprep
RUN scripts/theme.sh -b jcc_deprep
RUN scripts/theme.sh -i jcc_newsroom
RUN scripts/theme.sh -b jcc_newsroom
