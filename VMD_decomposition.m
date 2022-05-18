function [ measuredHeartbeat]=VMD_decomposition(HRsignal)
format long g
valueofk= [4,5,7,8,10,12,15,20,25,30];             %Kֵ�б仯���Ƿ�̶�һ��ֵ��ֻ�ֽ�һ��       ��������ԭ����   Сֵ�����Ҳ���   ��ֵ�����в���Ҫ��
Y = (-2^16/2:2^16/2-1)*(20)/2^16;
w=0;
dyy = [];
for Location=1          %!!!!!!!!!!!!!!!!!!!!!!!!                      %���ﵥ����Location��ֵ���Ե����õ�ĳ��λ�õĽ��
    
    flagheart = 0;   %�õ��������1
    
    
    DData = HRsignal;
%     
    for j=1:1:size(valueofk,2)                                    %��������VMD�ֽ��� valueofk�е�Kֵ��������
        
        if( flagheart == 0)                       %û���ҵ����ʺͺ������������K����VMD�ֽ�
            K = valueofk(j);          
            u = VMD_hb(DData,K);
            for i =1:K
                fre(i,:)=abs(fftshift(fft(u(i,:),2^16)))*1000;
                [resultvalue,result] = max(fre(i,:));
                provalue(i) = abs(Y(result)); 
%                 figure%�洢���зֽ����Ƶ��ֵ
%                 plot(Y,fre(i,:));
%     xlabel('Ƶ��/����');
%     ylabel('����');
                
            end
            for i = 1:K                           
                if(   provalue(i) > 1 &&  provalue(i) < 1.6   )     
%                 if(   provalue(i) > 0.65 &&  provalue(i) < 1.6   )    
                    energyofu(i) = sum(u(i,:).*u(i,:));
                    w=w+1;               
                    flagheart = 1;
                end
            end
            if flagheart == 1
                 [energyofumax,energyofumaxi] = max(energyofu);  
                 measuredHeartbeat(Location) = provalue(energyofumaxi);
                provalue = [];
                energyofmodule=energyofumax;
            end
        else
            break
        end
    end
    
    if (flagheart==0)
        measuredHeartbeat(Location) = -1;
    end
    provalue=[];
    
end

measuredHeartbeat=measuredHeartbeat.*60;
if (energyofmodule < 10^-9)
    measuredHeartbeat = 0;
end

% for i =1:K
%     figure
%     plot(u(i,:))                                           %�洢���зֽ����Ƶ��ֵ
%     
% end
% for i =1:K
%     figure                                            %�洢���зֽ����Ƶ��ֵ
%     plot(Y,fre(i,:))
% end



