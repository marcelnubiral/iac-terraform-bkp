  #!/bin/bash
  sudo echo ${var.domain_pwd} | realm join -U ${var.domain_user} aws.local