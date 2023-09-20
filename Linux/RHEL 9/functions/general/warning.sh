#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   warning.sh                                 #
# Description: Prints usage warning to the terminal to    #
#              inform users of the impact of using this   #
#              tool                                       #
#                                                         #
###########################################################

# Display warning message to users
warning()
{
	echo -e "***************************************************************"
	echo -e "*******\e[1;31mWARNING\e[0m*******\e[1;31mWARNING\e[0m*******\e[1;31mWARNING\e[0m*******\e[1;31mWARNING\e[0m*******"
	echo -e "***************************************************************"
	echo -e "* *                                                         * *"
	echo -e "* *    This tool makes significant changes to your system   * *"
	echo -e "*\e[1;31mW\e[0m*    that could cause a loss of functionality!            *\e[1;31mW\e[0m*"
	echo -e "*\e[1;31mA\e[0m*                                                         *\e[1;31mA\e[0m*"
	echo -e "*\e[1;31mR\e[0m*    Please ensure that the tool is thoroughly assessed   *\e[1;31mR\e[0m*"
	echo -e "*\e[1;31mN\e[0m*    in a dev/test environment before introducing it to   *\e[1;31mN\e[0m*"
	echo -e "*\e[1;31mI\e[0m*    a production system.                                 *\e[1;31mI\e[0m*"
	echo -e "*\e[1;31mN\e[0m*                                                         *\e[1;31mN\e[0m*"
	echo -e "*\e[1;31mG\e[0m*    Failure to perform comprehensive testing may lead    *\e[1;31mG\e[0m*"
	echo -e "* *    to service interruption!                             * *"
	echo -e "* *                                                         * *"
	echo -e "***************************************************************"
	echo -e "*******\e[1;31mWARNING\e[0m*******\e[1;31mWARNING\e[0m*******\e[1;31mWARNING\e[0m*******\e[1;31mWARNING\e[0m*******"
	echo -e "***************************************************************\n"
}