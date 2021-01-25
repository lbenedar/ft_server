# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lbenedar <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/21 13:48:50 by lbenedar          #+#    #+#              #
#    Updated: 2021/01/24 20:31:38 by lbenedar         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ID = container_id.txt

IMAGE_NAME = ft_server

TAG = lbenedar

IHTTP = 80

OHTTP = 7777

IHTTPS = 443

OHTTPS = 443

RUNFLAGS = -ti -p $(OHTTP):$(IHTTP) --cidfile $(ID)

OK = \033[38;5;82m

N = \033[30;0m

KO = \033[38;5;160m

WR = \033[38;5;214m

DOCKER = sudo docker

all: up

build:
	@$(DOCKER) build -t $(IMAGE_NAME):$(TAG) . 2>/dev/null

clean:
ifneq ($(wildcard $(ID)), )
	@$(DOCKER) rm $(shell sudo docker stop $(shell head -n 1 $(ID)))
	@echo  "${OK}\n################### clean has been succesful ###################\n${N}"
	@rm -f $(ID)
else
	@echo  "${WR}\n############## !!!already has been cleaned!!! ##############\n${N}"
endif

fclean: clean
ifneq ($(shell $(DOCKER) image ls -q $(IMAGE_NAME):$(TAG)), )
	@$(DOCKER) rmi $(IMAGE_NAME):$(TAG)
	@echo  "${OK}\n################### fclean has been succesful ###################\n${N}"
else
	@echo  "${WR}\n############## !!!already has been fcleaned!!! ##############\n${N}"
endif

images:
	@$(DOCKER) images

pause:
ifneq ($(wildcard $(ID)), )
	@$(DOCKER) pause $(shell head -n 1 $(ID))
else
	@echo  "${KO}\n############## !!!container doesn't exist!!! ##############\n${N}"
endif

ps:
	@$(DOCKER) ps -a

restart:
ifneq ($(wildcard $(ID)), )
	@$(DOCKER) restart $(shell head -n 1 $(ID))
else
	@echo  "${KO}\n############## !!!container doesn't exist!!! ##############\n${N}"
endif

run:
ifneq ($(shell $(DOCKER) image ls -q $(IMAGE_NAME):$(TAG)), )
	@$(DOCKER) run $(RUNFLAGS) $(IMAGE_NAME):$(TAG)
	@echo  "${OK}\n############## container has been succesfully run ##############\n${N}"
else
	@echo  "${KO}\n############## !!!image doesn't exist!!! ##############\n${N}"
endif

start:
ifneq ($(wildcard $(ID)), )
	@$(DOCKER) start -i $(shell head -n 1 $(ID))
else
	@echo  "${KO}\n############## !!!container doesn't exist!!! ##############\n${N}"
endif

unpause:
ifneq ($(wildcard $(ID)), )
	@$(DOCKER) unpause $(shell head -n 1 $(ID))
else
	@echo  "${KO}\n############## !!!container doesn't exist!!! ##############\n${N}"
endif

up:
ifeq ($(wildcard $(ID)), )
	@make build
	@make run
	@echo  "${OK}\n################### up has been succesful ###################\n${N}"
else
	@echo  "${WR}\n############### !!!already has been up!!! ###############\n${N}"
endif

.PHONY: all build clean fclean images pause ps restart run start unpause up 