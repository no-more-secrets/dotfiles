ifneq ($(origin REBUILD_YCM),undefined)
    rebuild-ycm := --rebuild-ycm
endif

_:
	bash sync $(rebuild-ycm)
