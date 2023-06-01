getP2<-function(pG,combine="fisher"){
  #given a pG returns two equal p-values such as   combfunc(p1,p2)=pG
  if(combine=="fisher"){
    ch=qchisq(pG,4,lower.tail = FALSE)
    return(sqrt(exp(-ch/2)))
  }
  
  if(combine=="norminv"){
    return(pnorm(qnorm(pG)*sqrt(2)/2))
  }
}

plotP2<-function(x,threshold=0.05){
  
  if(class(x)!="data.frame" | dim(x)[1]<1 | !all(c("ID","pNDE","pPERT","pG","pGFdr","pGFWER")%in%names(x)))
  {
    stop("plotP can be applied only to a dataframe produced by spia function!!!") 
  }
  
  
  if(threshold<x[1,"pGFdr"]){
    msg<-paste("The threshold value should be",x[1,"pGFdr"],"or higher!!!");
    stop(msg);
  }
  
  pb<-x[,"pPERT"]
  ph<-x[,"pNDE"]
  
  #determine what combine method was used to convert ph and pb into pG
  combinemethod=ifelse(sum(combfunc(pb,ph,"fisher")==x$pG)>sum(combfunc(pb,ph,"norminv")==x$pG),"fisher","norminv")
  
  
  okx<-(ph<1e-6)
  oky<-(pb<1e-6)
  
  ph[ph<1e-6]<-1e-6
  pb[pb<1e-6]<-1e-6
  
  plot(-log(ph),-log(pb),xlim=c(0,max(c(-log(ph),-log(pb))+1,na.rm=TRUE)),
       ylim=c(0,max(c(-log(ph),-log(pb)+1),na.rm=TRUE)),pch=19,main="SPIA two-way evidence plot",cex=1.5,
       xlab="-log(P NDE)",ylab="-log(P PERT)")
  tr<-threshold/dim(na.omit(x))[1]
  abline(v=-log(tr),lwd=1,col="red",lty=2)
  abline(h=-log(tr),lwd=1,col="red",lty=2)
  
  if(combinemethod=="fisher"){
    points(c(0,-log(getP2(tr,"fisher")^2)),c(-log(getP2(tr,"fisher")^2),0),col="red",lwd=2,cex=0.7,type="l")
  }else{
    somep1=exp(seq(from=min(log(ph)),to=max(log(ph)),length=200))
    somep2=pnorm(qnorm(tr)*sqrt(2)-qnorm(somep1))
    points(-log(somep1),-log(somep2),col="red",lwd=2,cex=0.7,type="l") 
  }
  
  oks<-x[,"pGFWER"]<=threshold
  trold=tr
  tr<-max(x[,"pG"][x[,"pGFdr"]<=threshold])
  if(tr<=trold){tr=trold*1.03}
  
  if(combinemethod=="fisher"){
    points(c(0,-log(getP2(tr,"fisher")^2)),c(-log(getP2(tr,"fisher")^2),0),col="blue",lwd=2,cex=0.7,type="l")
  }else{
    somep1=exp(seq(from=min(log(ph)),to=max(log(ph)),length=200))
    somep2=pnorm(qnorm(tr)*sqrt(2)-qnorm(somep1))
    points(-log(somep1),-log(somep2),col="blue",lwd=2,cex=0.7,type="l") 
  }
  
  abline(v=-log(tr),lwd=1,col="blue",lty=2)
  abline(h=-log(tr),lwd=1,col="blue",lty=2)
  text(-log(ph)[oks]+0.70,-log(pb)[oks],labels=as.vector(x$ID)[oks],cex=0.65)
  oks2<-x[,"pGFdr"]<=threshold
  points(-log(ph)[oks2],-log(pb)[oks2],pch=19,col="blue",cex=1.5)
  points(-log(ph)[oks],-log(pb)[oks],pch=19,col="red",cex=1.5)
  
  text(-log(ph)[oks2]+0.70,-log(pb)[oks2],labels=as.vector(x$ID)[oks2],cex=0.65)
  
  if (sum(okx) > 0) {
    points(-log(ph)[okx] - 0.12, -log(pb)[okx], pch = "|", col = "black", cex = 1.5)
  }
  if (sum(!is.na(oky) & oky > 0)) { #Se utiliza la función is.na() para verificar si oky tiene valores NA 
    points(-log(ph)[oky[!is.na(oky) & oky > 0]], -log(pb)[oky[!is.na(oky) & oky > 0]] - 0.12, pch = "_", col = "black", cex = 1.5)
  }
  
}