import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(-3,3,100)
p = [5,1,0,3]
y = np.polyval(p,x)
plt.show()


def plot_data(data):
    time_data = data[:,0]
    x_data = data[:,1]
    y_data = data[:,2]
    fig, axs = plt.subplots(2,1)
    axs[0].plot(time_data, x_data, 'b.')
    axs[1].plot(time_data, y_data, 'g.')
    t_model = np.linspace(time_data.min(), time_data.max(), 100)
    poly_x = np.polyfit(time_data, x_data, 1)
    x_model = np.polyval(poly_x, t_model)
    axs[0].plot(t_model, x_model, 'b-')
    axs[0].set(ylabel=r'$x$')
    axs[1].set(xlabel=r'$x$', ylabel=r'$y$')
    axs[1].plot(t_model, x_model, 'g--')
    plt.show()

plot_data(data)

