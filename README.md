## Выполнение тестового задания RTL, FPGA, SoCIntegration от Yadro
Само задание: https://drive.yadro.com/s/qYrrwGoeA8aMpF6
![image](https://github.com/user-attachments/assets/74266a5a-e216-4861-9407-5a0ca43643f9)

Все файлы есть в репозитории.

1.Схема в draw.io

![image](https://github.com/user-attachments/assets/7c575de0-514b-4bac-a54f-fbd08f6f6473)


2,9,10. HDL задание выполнял в САПРе Vivado под FPGA Nexys-A7-100T, Python код приложен к проекту.
Схема RTL анализа:

![image](https://github.com/user-attachments/assets/67642475-4512-460d-bbba-0fef027b37db)

11. Среди возможных способов защиты от переполнения можно выделить предварительное увеличение разрядности выходного значения или использование модифицированных кодов, встроенных DSP блоков.

12. При анализе использования аппаратных ресурсов во вкладке Синтеза -> Утилизация оценил общую информацию. Используются примитивы FDCE, CARRY4, также LUT'ы. Получается, что Vivado автоматически использовал встроенные примитивы FPGA.

![image](https://github.com/user-attachments/assets/cd4e6577-dc47-4c9a-a74b-97d13ec88556)
![image](https://github.com/user-attachments/assets/e7c52c0f-1843-4ad8-9cfa-6da627ebf88c)

13. Максимальная тактовая частота, на которой схема будет работать равна 194 МГц. Это значение было рассчитано вручную - сперва я создал файл ограничений и добавил в него период синхроимпульса 1 нс(1 ГГц), но на такой частоте slack был -4,154, а так как частота обратно пропорциональна времени, то 1/(1нс-(-4,154нс))=194 МГц.
После этого slack стал положительным. То есть я уменьшил частоту, чтобы избавиться от отрицательного slack.

![image](https://github.com/user-attachments/assets/8d28c69a-cfae-4eaa-9eb1-159e59151064)
![image](https://github.com/user-attachments/assets/89f58496-eccf-441d-bbf6-76562702266a)
