from shapely.geometry import Point
import adjustText as aT
geometry = [Point(xy) for xy in zip(safespace['longitude'], safespace['latitude'])]
final = GeoDataFrame(safespace, geometry=geometry)
mp['center'] = mp['geometry'].centroid
mp_points = mp.copy()
mp_points.set_geometry('center',inplace = True)
fig,ax=plt.subplots(figsize=(18,18))
ax.set_title('Health facilities and Safe spaces in DREAMS districts (Central Uganda)',fontdict={'fontsize':'20','fontweight':'3'})
mp.plot(ax=ax,alpha=0.4,edgecolor="grey", color="orange")
final[final['type']=='Community'].plot(ax=ax ,marker='^', color='blue', markersize=15,label='Community')
final[final['type']=='Model'].plot(ax=ax ,marker='*', color='red', markersize=20,label='Model')
final[final['type']=='Facility'].plot(ax=ax ,marker='o', color='green', markersize=5,label='Facility')
plt.legend(prop={'size':15})
names=[]
for x,y,label in zip(mp_points.geometry.x,mp_points.geometry.y,mp_points['DName2018']):
    names.append(plt.text(x,y,label, fontSize = 10))
aT.adjust_text(names,force_points=0.3,force_text=0.8,expand_points=(1,1),expand_text=(1,1),
              arrowprops=dict(arrowstyle='-',color='black',lw=0.5))
